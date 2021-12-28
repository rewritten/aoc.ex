defmodule Aoc.HydrothermalVenture do
  def parse(text) do
    text
    |> String.split(~r([^\d]+), trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4)
    |> Enum.map(&List.to_tuple/1)
  end

  def part_1(data) do
    data
    |> Enum.flat_map(fn tuple -> diag(tuple, false) end)
    |> Enum.frequencies()
    |> Enum.count(&(!match?({_, 1}, &1)))
  end

  def part_2(data) do
    data
    |> Enum.flat_map(fn tuple -> diag(tuple, true) end)
    |> Enum.frequencies()
    |> Enum.count(&(!match?({_, 1}, &1)))
  end

  defp diag({a, b, a, d}, _), do: Enum.map(b..d, &{a, &1})
  defp diag({a, b, c, b}, _), do: Enum.map(a..c, &{&1, b})
  defp diag(_, false), do: []
  defp diag({a, b, c, d}, _), do: Enum.zip(a..c, b..d)
end
