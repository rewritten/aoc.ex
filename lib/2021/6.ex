defmodule Aoc.Lanternfish do
  def parse(text) do
    text
    |> String.to_charlist()
    |> Enum.frequencies()
    |> then(&for c <- ?0..?8, do: Map.get(&1, c, 0))
    |> Stream.iterate(fn [a, b, c, d, e, f, g, h, i] -> [b, c, d, e, f, g, h + a, i, a] end)
  end

  def part_1(data), do: data |> Enum.at(80) |> Enum.sum()
  def part_2(data), do: data |> Enum.at(256) |> Enum.sum()
end
