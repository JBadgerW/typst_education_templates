(function () {
  'use strict';

  function validateBoardData(data) {
    if (typeof data !== 'object' || data === null || Array.isArray(data)) {
      return { ok: false, error: 'File does not contain a JSON object.' };
    }

    const problems = data.problems;
    if (!Array.isArray(problems) || problems.length === 0) {
      return { ok: false, error: 'File needs a non-empty "problems" array.' };
    }

    for (let i = 0; i < problems.length; i++) {
      const p = problems[i];
      if (!p || typeof p !== 'object') {
        return { ok: false, error: `Problem ${i + 1} is not an object.` };
      }
      for (const key of ['q_svg', 'a_svg']) {
        if (typeof p[key] !== 'string' || !p[key].trim()) {
          return { ok: false, error: `Problem ${i + 1} is missing a valid "${key}".` };
        }
      }
    }

    return {
      ok: true,
      problems,
      title: typeof data.title === 'string' ? data.title : undefined,
    };
  }

  function renderProblemSvg(el, svgMarkup) {
    el.innerHTML = svgMarkup;
  }

  // Generalizes the original two-pane queue logic (a shared `nextIndex`
  // pointer plus per-pane {problemIndex, showingAnswer} state) to any pane
  // count. Whichever pane is clicked next claims the next unclaimed problem
  // - there's no left/right-specific list.
  function createController(paneCount, paneEls) {
    let problems = [];
    let nextIndex = 0;
    let paneState = [];

    function render(paneId) {
      const el = paneEls[paneId];
      const state = paneState[paneId];
      if (!state) return;

      if (state.problemIndex >= problems.length) {
        el.innerHTML = '<span class="done">Done</span>';
        return;
      }

      const prob = problems[state.problemIndex];
      const svg = state.showingAnswer ? prob.a_svg : prob.q_svg;
      renderProblemSvg(el, svg);
    }

    function loadProblems(newProblems) {
      problems = newProblems;
      nextIndex = Math.min(paneCount, problems.length);
      paneState = Array.from({ length: paneCount }, (_, i) => ({
        problemIndex: i < problems.length ? i : problems.length,
        showingAnswer: false,
      }));
      for (let i = 0; i < paneCount; i++) render(i);
    }

    function handleClick(paneId) {
      if (!paneState.length) return; // no file loaded yet
      const state = paneState[paneId];
      if (!state || state.problemIndex >= problems.length) return;

      if (!state.showingAnswer) {
        state.showingAnswer = true;
      } else if (nextIndex < problems.length) {
        state.problemIndex = nextIndex;
        nextIndex++;
        state.showingAnswer = false;
      } else {
        state.problemIndex = problems.length; // mark done
        state.showingAnswer = false;
      }

      render(paneId);
    }

    return { loadProblems, handleClick };
  }

  function initLoader({ dropZoneEl, fileInputEl, errorEl, onLoaded }) {
    function showError(message) {
      if (errorEl) errorEl.textContent = message;
    }

    function handleFile(file) {
      if (!file) return;

      const looksLikeJson =
        file.type === 'application/json' || /\.json$/i.test(file.name);
      if (!looksLikeJson) {
        showError(`"${file.name}" doesn't look like a .json file.`);
        return;
      }

      const reader = new FileReader();
      reader.onerror = () => showError('Could not read that file.');
      reader.onload = () => {
        let data;
        try {
          data = JSON.parse(reader.result);
        } catch (e) {
          showError(`That file isn't valid JSON: ${e.message}`);
          return;
        }

        const result = validateBoardData(data);
        if (!result.ok) {
          showError(result.error);
          return;
        }

        showError('');
        onLoaded(result);
      };
      reader.readAsText(file);
    }

    dropZoneEl.addEventListener('click', () => fileInputEl.click());
    fileInputEl.addEventListener('change', () => {
      handleFile(fileInputEl.files[0]);
      fileInputEl.value = '';
    });

    dropZoneEl.addEventListener('dragover', (e) => {
      e.preventDefault();
      dropZoneEl.classList.add('dragover');
    });
    dropZoneEl.addEventListener('dragleave', () => {
      dropZoneEl.classList.remove('dragover');
    });
    dropZoneEl.addEventListener('drop', (e) => {
      e.preventDefault();
      dropZoneEl.classList.remove('dragover');
      handleFile(e.dataTransfer.files && e.dataTransfer.files[0]);
    });

    // Without this, dropping a file anywhere outside dropZoneEl navigates
    // the whole tab away to open it directly, silently destroying any live
    // board state.
    document.addEventListener('dragover', (e) => e.preventDefault());
    document.addEventListener('drop', (e) => e.preventDefault());
  }

  window.Board = {
    validateBoardData,
    renderProblemSvg,
    createController,
    initLoader,
  };
})();
