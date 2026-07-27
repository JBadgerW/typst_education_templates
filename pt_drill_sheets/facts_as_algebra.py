import argparse
import random

import fact_families
from drill_common import format_family_ranges, resolve_seed, write_sheet

ALGEBRA_OPERATIONS = {
    "Addition": {
        "typst_file": "algebra_1.typ",
        "output_prefix": "alg_add_facts",
        "op": "addition",
    },
    "Subtraction": {
        "typst_file": "algebra_1.typ",
        "output_prefix": "alg_sub_facts",
        "op": "subtraction",
    },
    "Multiplication": {
        "typst_file": "algebra_1.typ",
        "output_prefix": "alg_mult_facts",
        "op": "multiplication",
    },
    "Division": {
        "typst_file": "algebra_1.typ",
        "output_prefix": "alg_div_facts",
        "op": "division",
    },
}


def build_algebra_arg_parser(description):
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
    parser.add_argument(
        "--unknown",
        type=str,
        default="x",
        help="Letters to draw the unknown variable from, e.g. --unknown xyn. "
        "Non-letter characters are ignored; each problem gets a random letter "
        "from the resulting set. Defaults to x.",
    )
    return parser


def parse_unknown_letters(raw):
    """Strip non-letters from raw input and return the deduped, sorted set of
    single-character letters left over (sorted for seed-reproducibility)."""
    letters = sorted({c for c in raw if c.isalpha()})
    if not letters:
        raise ValueError("No letters found in the unknown-letter input.")
    return letters


def generate_algebra_problems(families, max_factor, count, rng, unknown_letters):
    family_list = list(families) if families else list(range(1, max_factor + 1))
    facts = fact_families.get_facts(
        families=family_list, num_facts=count, max_factor=max_factor, rng=rng
    )
    return [
        {
            "family": family,
            "member": member,
            "reverse": rng.choice([True, False]),
            "unknown": rng.choice(unknown_letters),
        }
        for family, member in facts
    ]


def generate_algebra_sheet(
    operation,
    families,
    max_factor,
    count,
    seed,
    unknown,
    typst_file,
    output_prefix,
    op,
    output_path=None,
    output_dir=None,
):
    seed = resolve_seed(seed)
    rng = random.Random(seed)

    unknown_letters = parse_unknown_letters(unknown)
    problems = generate_algebra_problems(
        families, max_factor, count, rng, unknown_letters
    )

    letters_str = ", ".join(unknown_letters)
    data = {
        "seed": seed,
        "title": f"Algebra: {operation} Facts",
        "ws-details": f"Solve for the unknown. Families: {format_family_ranges(families, max_factor)}",
        "operation": op,
        "problems": problems,
    }

    return write_sheet(
        data,
        seed,
        families,
        max_factor,
        typst_file,
        output_prefix,
        output_path,
        output_dir,
    )
