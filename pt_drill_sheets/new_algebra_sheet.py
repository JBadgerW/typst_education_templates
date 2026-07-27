from facts_as_algebra import ALGEBRA_OPERATIONS, build_algebra_arg_parser, generate_algebra_sheet

if __name__ == "__main__":
    parser = build_algebra_arg_parser("Generate an algebra fact-family drill sheet.")
    parser.add_argument(
        "--operation",
        choices=list(ALGEBRA_OPERATIONS.keys()),
        default="Addition",
    )
    args = parser.parse_args()

    seed, output_path = generate_algebra_sheet(
        operation=args.operation,
        families=args.families,
        max_factor=args.max_factor,
        count=args.count,
        seed=args.seed,
        unknown=args.unknown,
        **ALGEBRA_OPERATIONS[args.operation],
    )
    print(f"Wrote {output_path} (seed {seed})")
