defmodule Aoc.SyntaxScoring do
  def parse(text), do: String.split(text)

  def part_1(data) do
    data
    |> Enum.map(&(&1 |> check("") |> elem(0)))
    |> Enum.sum()
  end

  def part_2(data) do
    scores =
      for line <- data, {s, unmatched} = check(line, ""), s == 0 do
        unmatched |> score() |> Integer.undigits(5)
      end

    scores
    |> Enum.sort()
    |> Enum.at(scores |> length() |> div(2))
  end

  def check("(" <> rest, acc), do: check(rest, ")" <> acc)
  def check("[" <> rest, acc), do: check(rest, "]" <> acc)
  def check("{" <> rest, acc), do: check(rest, "}" <> acc)
  def check("<" <> rest, acc), do: check(rest, ">" <> acc)
  def check(<<c, rest::binary>>, <<c, acc::binary>>), do: check(rest, acc)
  def check(")" <> _, _), do: {3, ""}
  def check("]" <> _, _), do: {57, ""}
  def check("}" <> _, _), do: {1197, ""}
  def check(">" <> _, _), do: {25137, ""}
  def check("", unmatched), do: {0, unmatched}

  def score(""), do: []
  def score(")" <> rest), do: [1 | score(rest)]
  def score("]" <> rest), do: [2 | score(rest)]
  def score("}" <> rest), do: [3 | score(rest)]
  def score(">" <> rest), do: [4 | score(rest)]
end
