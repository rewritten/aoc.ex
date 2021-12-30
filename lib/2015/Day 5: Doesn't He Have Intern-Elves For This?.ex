defmodule Aoc.DoesntHeHaveInternElvesForThis do
  def solve(1, text) do
    text
    |> Input.l()
    |> Enum.count(
      &(Regex.match?(~r/[aeiou].*[aeiou].*[aeiou]/, &1) && Regex.match?(~r/(.)\1/, &1) &&
          !Regex.match?(~r/ab|cd|pq|xy/, &1))
    )
  end

  def solve(2, text) do
    text
    |> Input.l()
    |> Enum.count(&(Regex.match?(~r/(..).*\1/, &1) && Regex.match?(~r/(.).\1/, &1)))
  end
end
