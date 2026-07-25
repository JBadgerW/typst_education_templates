import math
import random
from typing import Sequence

FACT_FAMILIES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
DEFAULT_NUMBER_OF_FACTS = 206
MAX_FACTOR = 12


def get_facts(
    families: Sequence[int] = FACT_FAMILIES,
    num_facts: int = DEFAULT_NUMBER_OF_FACTS,
    repeat_freely: bool = False,
    max_factor: int = MAX_FACTOR,
    rng=None,
) -> list[tuple[int, int]]:
    """This function returns a given number of (family, member) pairs in random
    order for the making of mathematical fact problems from within a given set
    of fact families.

    (Note on nomenclature: a math fact like '2x8=16' is given a family name
    from its first factor, 2, and a member name from its second, 8. All the
    facts that look like 2x1=2, 2x2=4, 2x3=6, etc, are from the '2 family'. By
    extension, I'm doing the same with division, addition, and subtraction
    facts as well. The division and subtraction facts are in interesting case
    in which the family name comes from the divisor and subtrahend,
    respectively.)

    By default, the function limits the number of repeats by adding the pool of
    facts to itself until there is more than the number of required facts and
    then sampling from pool of limited repeats.

    If, on the other hand, the function is instructed to repeat freely, then it
    just gets a random choice from the pool as many times as necessary until
    we have the required number of problems.
    """
    rng = rng or random

    if num_facts < 1:
        raise ValueError("Number of facts to return must be greater than 0.")

    all_facts = [
        (family, member) for family in families for member in range(1, max_factor + 1)
    ]

    if not all_facts:
        raise ValueError("No facts available for the given families/max_factor.")

    if repeat_freely:
        problems = rng.choices(all_facts, k=num_facts)
    else:
        pool = all_facts * math.ceil(num_facts / len(all_facts))

        problems = rng.sample(pool, num_facts)

    return problems


if __name__ == "__main__":
    my_problems = get_facts(
        families=(3, 6, 9, 12),
        num_facts=723,
        repeat_freely=False,
        max_factor=10,
        rng=random.Random(28056),
    )

    print(my_problems)
    print(f"\n{len(my_problems)} Facts, baby!")
