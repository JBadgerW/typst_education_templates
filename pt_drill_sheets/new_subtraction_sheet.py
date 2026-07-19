from drill_common import build_arg_parser, build_subtitle, run_sheet


def main():
    parser = build_arg_parser("Generate a subtraction drill sheet.")
    args = parser.parse_args()

    subtitle = build_subtitle(
        args.families, f"Subtract from up to {2 * args.max_factor}"
    )

    run_sheet(
        args,
        typst_file="subtraction_1.typ",
        output_prefix="sub_facts",
        title=f"{args.count} Facts",
        subtitle=subtitle,
    )


if __name__ == "__main__":
    main()
