from drill_common import build_arg_parser, build_subtitle, run_sheet


def main():
    parser = build_arg_parser("Generate a division drill sheet.")
    args = parser.parse_args()

    subtitle = build_subtitle(
        args.families,
        f"Divide up to {args.max_factor ** 2} by {args.max_factor}",
    )

    run_sheet(
        args,
        typst_file="division_1.typ",
        output_prefix="div_facts",
        title=f"{args.count} Facts",
        subtitle=subtitle,
    )


if __name__ == "__main__":
    main()
