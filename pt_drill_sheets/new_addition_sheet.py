from drill_common import OPERATIONS, build_arg_parser, generate_sheet


def main():
    parser = build_arg_parser("Generate an addition drill sheet.")
    args = parser.parse_args()

    generate_sheet(
        families=args.families,
        max_factor=args.max_factor,
        count=args.count,
        seed=args.seed,
        **OPERATIONS["Addition"],
    )


if __name__ == "__main__":
    main()
