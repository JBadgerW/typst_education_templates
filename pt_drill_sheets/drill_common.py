import argparse
import json
import os
import random
import subprocess


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


def run_sheet(args, typst_file, output_prefix, title, subtitle):
    seed = args.seed if args.seed is not None else random.randint(100_000, 999_999)
    rng = random.Random(seed)

    problems = generate_problems(
        args.families, max_factor=args.max_factor, count=args.count, rng=rng
    )

    data = {
        "seed": seed,
        "title": title,
        "subtitle": subtitle,
        "problems": [{"a": a, "b": b} for a, b in problems],
    }

    data_path = f"data_{seed}.json"
    with open(data_path, "w") as f:
        json.dump(data, f)

    try:
        subprocess.run(
            [
                "typst",
                "compile",
                typst_file,
                "--input",
                f"data={data_path}",
                f"{output_prefix}_{seed}.pdf",
            ]
        )
    finally:
        os.remove(data_path)


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


def build_subtitle(families, default):
    if families:
        return f"Facts: {', '.join(str(f) for f in sorted(set(families)))}"
    return default
