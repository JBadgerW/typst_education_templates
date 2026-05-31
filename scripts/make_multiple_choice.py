import re
import sys
from pathlib import Path

cl_arguments = sys.argv[1:]

options = [arg.strip("-") for arg in cl_arguments if arg[0] == "-"]

file_paths = [Path(arg) for arg in cl_arguments if arg[0] != "-"]

if len(file_paths) > 1:
    raise ValueError("Too many filenames passed.")

with open(file_paths[0], "r") as f:
    stripped_lines = [line.strip() for line in f.readlines()]
    file_blob = "\n".join(stripped_lines)

piece_blobs = re.split(r"[\n]{2,}", file_blob)

pieces = []

for blob in piece_blobs:
    piece = [line for line in blob.split("\n")]
    pieces.append(piece)

# print(pieces)
#
# breakpoint()

for piece in pieces:
    if len(piece) > 2:
        question = [f"#question()[{piece[0]}"]
        question.append("  #choices(")

        for choice in piece[1:]:
            question.append(f"    [{choice}],")

        question.append("  )")
        question.append("]\n")

        print("\n".join(question))

    else:
        print("\n".join(piece) + "\n")
