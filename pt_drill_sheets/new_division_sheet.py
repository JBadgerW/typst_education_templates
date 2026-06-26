import subprocess
import random

seed = random.randint(100_000, 999_999)

subprocess.run(
    [
        "typst",
        "compile",
        "division_1.typ",
        "--input",
        f"seed={seed}",
        f"div_facts_{seed}.pdf",
    ]
)
