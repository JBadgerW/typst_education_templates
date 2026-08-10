"""Compile a Typst-markup problem set into board.json for board.html.

Source file shape:
    {
      "title": "optional label",
      "problems": [
        {"question": "Solve for $x$: $3x + 7 = 22$", "answer": "$x = 5$"},
        ...
      ]
    }

`question` and `answer` are real Typst markup. Each is compiled to a tightly-cropped,
self-contained SVG (glyphs baked in as vector paths, no external font
references) and embedded as a string in the output board.json, which
board.html loads directly - no separate image files, no runtime Typst
dependency in the browser.
"""

import argparse
import json
import pathlib
import sys
import tempfile

import typst

SNIPPET_TEMPLATE = """\
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: "New Computer Modern", size: {size}pt)
{body}
"""

ANSWER_WRAPPER = '#text(fill: red, weight: "bold")[{body}]'


def render_snippet(markup, size=28):
    with tempfile.NamedTemporaryFile(
        "w", suffix=".typ", delete=False, encoding="utf-8"
    ) as f:
        f.write(SNIPPET_TEMPLATE.format(size=size, body=markup))
        path = pathlib.Path(f.name)
    try:
        svg_bytes = typst.compile(str(path), format="svg", output=None)
    finally:
        path.unlink()
    return svg_bytes.decode("utf-8")


def load_source(source_path):
    try:
        data = json.loads(pathlib.Path(source_path).read_text(encoding="utf-8"))
    except FileNotFoundError:
        raise SystemExit(f"error: source file not found: {source_path}")
    except json.JSONDecodeError as exc:
        raise SystemExit(f"error: {source_path} is not valid JSON: {exc}")

    if not isinstance(data, dict):
        raise SystemExit("error: source file must contain a JSON object")

    problems = data.get("problems")
    if not isinstance(problems, list) or not problems:
        raise SystemExit("error: source file needs a non-empty 'problems' array")

    for i, p in enumerate(problems):
        if not isinstance(p, dict):
            raise SystemExit(f"error: problem {i} is not an object")
        for key in ("question", "answer"):
            value = p.get(key)
            if not isinstance(value, str) or not value.strip():
                raise SystemExit(f"error: problem {i} is missing a non-empty '{key}'")

    return data.get("title"), problems


def build(source_path, output_path):
    title, problems = load_source(source_path)

    out_problems = []
    for i, p in enumerate(problems):
        print(f"compiling problem {i + 1}/{len(problems)}...", file=sys.stderr)
        q_svg = render_snippet(p["question"])
        a_svg = render_snippet(ANSWER_WRAPPER.format(body=p["answer"]))
        out_problems.append({"q_svg": q_svg, "a_svg": a_svg})

    out = {"title": title, "problems": out_problems}
    pathlib.Path(output_path).write_text(json.dumps(out), encoding="utf-8")
    print(f"wrote {output_path} ({len(out_problems)} problems)", file=sys.stderr)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "source", nargs="?", default="problems.json", help="Typst-markup source JSON"
    )
    parser.add_argument(
        "-o", "--output", default="board.json", help="compiled output JSON for board.html"
    )
    args = parser.parse_args()
    build(args.source, args.output)


if __name__ == "__main__":
    main()
