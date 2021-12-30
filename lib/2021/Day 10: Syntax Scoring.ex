defmodule Aoc.SyntaxScoring do
  def solve(1, input) do
    input
    |> Input.l()
    |> Enum.map(&(&1 |> check("") |> elem(0)))
    |> Enum.sum()
  end

  def solve(2, input) do
    scores =
      for line <- Input.l(input), {s, unmatched} = check(line, ""), s == 0 do
        unmatched |> score() |> Integer.undigits(5)
      end

    scores
    |> Enum.sort()
    |> Enum.at(scores |> length() |> div(2))
  end

  defp check("(" <> rest, acc), do: check(rest, ")" <> acc)
  defp check("[" <> rest, acc), do: check(rest, "]" <> acc)
  defp check("{" <> rest, acc), do: check(rest, "}" <> acc)
  defp check("<" <> rest, acc), do: check(rest, ">" <> acc)
  defp check(<<c, rest::binary>>, <<c, acc::binary>>), do: check(rest, acc)
  defp check(")" <> _, _), do: {3, ""}
  defp check("]" <> _, _), do: {57, ""}
  defp check("}" <> _, _), do: {1197, ""}
  defp check(">" <> _, _), do: {25137, ""}
  defp check("", unmatched), do: {0, unmatched}

  defp score(""), do: []
  defp score(")" <> rest), do: [1 | score(rest)]
  defp score("]" <> rest), do: [2 | score(rest)]
  defp score("}" <> rest), do: [3 | score(rest)]
  defp score(">" <> rest), do: [4 | score(rest)]
end
