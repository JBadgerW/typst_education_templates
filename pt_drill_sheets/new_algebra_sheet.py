from facts_as_algebra import ALGEBRA_OPERATIONS, build_algebra_arg_parser, generate_algebra_sheet

ALL_OPERATIONS = ["addition", "subtraction", "multiplication", "division"]

if __name__ == "__main__":
    parser = build_algebra_arg_parser("Generate an algebra fact-family drill sheet.")
    parser.add_argument(
        "--operation",
        choices=list(ALGEBRA_OPERATIONS.keys()),
        default="Addition",
    )
    parser.add_argument(
        "--operations",
        choices=ALL_OPERATIONS,
        nargs="*",
        default=None,
        help="Only used with --operation Mixed: which operations to mix "
        "together, e.g. --operations addition subtraction. Defaults to all "
        "four.",
    )
    args = parser.parse_args()

    if args.operation == "Mixed":
        operations = args.operations or ALL_OPERATIONS
    else:
        operations = [ALGEBRA_OPERATIONS[args.operation]["op"]]

    seed, output_path = generate_algebra_sheet(
        operation=args.operation,
        operations=operations,
        families=args.families,
        max_factor=args.max_factor,
        count=args.count,
        seed=args.seed,
        unknown=args.unknown,
        typst_file=ALGEBRA_OPERATIONS[args.operation]["typst_file"],
        output_prefix=ALGEBRA_OPERATIONS[args.operation]["output_prefix"],
    )
    print(f"Wrote {output_path} (seed {seed})")
