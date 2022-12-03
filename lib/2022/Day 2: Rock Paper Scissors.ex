defmodule Aoc.RockPaperScissors do
  def solve(1, text),
    do:
      Enum.sum(
        for <<a, _, b>> <- String.split(text, "\n", trim: true),
            do: 3 * rem(b - a + 2, 3) + 1 + rem(b + 2, 3)
      )

  def solve(2, text),
    do:
      Enum.sum(
        for <<a, _, b>> <- String.split(text, "\n", trim: true),
            do: rem(b + a + 2, 3) + 1 + 3 * rem(b + 2, 3)
      )
end
