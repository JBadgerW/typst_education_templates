from drill_common import build_arg_parser, run_sheet, subtitle_for


def main():
    parser = build_arg_parser("Generate a division drill sheet.")
    args = parser.parse_args()

    subtitle = subtitle_for("Divide", args.families, args.max_factor)

    run_sheet(
        args,
        typst_file="division_1.typ",
        output_prefix="div_facts",
        title=f"{args.count} Facts",
        subtitle=subtitle,
    )


if __name__ == "__main__":
    main()
