import argparse
import json
import random
import subprocess
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent

OPERATIONS = {
    "Multiplication": {
        "typst_file": "multiplication_1.typ",
        "output_prefix": "mult_facts",
        "verb": "Multiply",
    },
    "Division": {
        "typst_file": "division_1.typ",
        "output_prefix": "div_facts",
        "verb": "Divide",
    },
    "Addition": {
        "typst_file": "addition_1.typ",
        "output_prefix": "add_facts",
        "verb": "Add",
    },
    "Subtraction": {
        "typst_file": "subtraction_1.typ",
        "output_prefix": "sub_facts",
        "verb": "Subtract",
    },
}


def build_arg_parser(description):
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument(
        "--families",
        type=int,
        nargs="*",
        default=None,
        help="Only draw problems touching these numbers, e.g. --families 7 8 9 12. "
        "Omit for the full table.",
    )
    parser.add_argument("--max-factor", type=int, default=12)
    parser.add_argument("--count", type=int, default=90)
    parser.add_argument(
        "--seed",
        type=int,
        default=None,
        help="Reuse a seed (e.g. from a previously generated sheet) to reproduce "
        "the same problems. Omit to generate a random one.",
    )
    return parser


def resolve_seed(seed):
    return seed if seed is not None else random.randint(100_000, 999_999)


def generate_sheet(
    families,
    max_factor,
    count,
    seed,
    typst_file,
    output_prefix,
    verb,
    output_path=None,
    output_dir=None,
):
    seed = resolve_seed(seed)
    rng = random.Random(seed)

    problems = generate_problems(families, max_factor=max_factor, count=count, rng=rng)

    data = {
        "seed": seed,
        "title": f"{count} Facts",
        "subtitle": subtitle_for(verb, families, max_factor),
        "problems": [{"a": a, "b": b} for a, b in problems],
    }

    if output_path is None:
        slug = family_slug(families, max_factor)
        base = Path(output_dir) if output_dir is not None else BASE_DIR
        output_path = base / f"{output_prefix}_{slug}_{seed}.pdf"
    else:
        output_path = Path(output_path)

    data_path = BASE_DIR / f"data_{seed}.json"
    with open(data_path, "w") as f:
        json.dump(data, f)

    try:
        subprocess.run(
            [
                "typst",
                "compile",
                "--font-path",
                str(BASE_DIR / "fonts"),
                str(BASE_DIR / typst_file),
                "--input",
                f"data={data_path.name}",
                str(output_path),
            ],
            check=True,
        )
    finally:
        data_path.unlink()

    return seed, output_path


def generate_problems(families, max_factor=12, count=90, rng=None):
    rng = rng or random

    if families is None:
        pool = [
            (a, b)
            for a in range(1, max_factor + 1)
            for b in range(1, max_factor + 1)
        ]
    else:
        family_set = set(families)
        pool = [
            (a, b)
            for a in range(1, max_factor + 1)
            for b in range(1, max_factor + 1)
            if a in family_set or b in family_set
        ]

    if count <= len(pool):
        return rng.sample(pool, count)
    return [rng.choice(pool) for _ in range(count)]


def format_family_ranges(families, max_factor):
    values = sorted(set(families)) if families else list(range(1, max_factor + 1))

    ranges = []
    start = prev = values[0]
    for v in values[1:]:
        if v == prev + 1:
            prev = v
            continue
        ranges.append((start, prev))
        start = prev = v
    ranges.append((start, prev))

    return ", ".join(f"{lo}-{hi}" if lo != hi else f"{lo}" for lo, hi in ranges)


def subtitle_for(verb, families, max_factor):
    return f"{verb} the following families: {format_family_ranges(families, max_factor)}"


def family_slug(families, max_factor):
    return format_family_ranges(families, max_factor).replace(", ", "_")
