import subprocess
import random

seed = random.randint(100_000, 999_999)

subprocess.run(
    [
        "typst",
        "compile",
        "subtraction_1.typ",
        "--input",
        f"seed={seed}",
        f"sub_facts_{seed}.pdf",
    ]
)
