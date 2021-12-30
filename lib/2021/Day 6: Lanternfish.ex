defmodule Aoc.Lanternfish do
  def solve(1, input), do: input |> parse() |> Enum.at(80) |> Enum.sum()
  def solve(2, input), do: input |> parse() |> Enum.at(256) |> Enum.sum()

  defp parse(text) do
    text
    |> Input.i()
    |> Enum.frequencies()
    |> then(&for c <- 0..8, do: Map.get(&1, c, 0))
    |> Stream.iterate(fn [a, b, c, d, e, f, g, h, i] -> [b, c, d, e, f, g, h + a, i, a] end)
  end
end
