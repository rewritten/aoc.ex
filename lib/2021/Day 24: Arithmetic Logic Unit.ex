defmodule Aoc.ArithmeticLogicUnit do
  def solve(1, text) do
    text
    |> parse()
    |> Enum.flat_map(fn
      {left, right, d} when d > 0 -> [{left, 9 - d}, {right, 9}]
      {left, right, d} when d < 0 -> [{left, 9}, {right, 9 + d}]
    end)
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Integer.undigits()
  end

  def solve(2, text) do
    text
    |> parse()
    |> Enum.flat_map(fn
      {left, right, d} when d > 0 -> [{left, 1}, {right, 1 + d}]
      {left, right, d} when d < 0 -> [{left, 1 - d}, {right, 1}]
    end)
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Integer.undigits()
  end

  defp parse(text) do
    text
    |> Input.l()
    |> Enum.chunk_every(18)
    |> Enum.map_reduce(0, fn block, level ->
      x = block |> Enum.at(5) |> String.split() |> Enum.at(2) |> String.to_integer()
      y = block |> Enum.at(15) |> String.split() |> Enum.at(2) |> String.to_integer()
      if x > 0, do: {{level + 1, y}, level + 1}, else: {{level, x}, level - 1}
    end)
    |> elem(0)
    |> Enum.with_index(fn {level, x}, i -> [level, {i, x}] end)
    |> Enum.group_by(&List.first/1, &List.last/1)
    |> Map.values()
    |> List.flatten()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [{left, y}, {right, x}] -> {left, right, x + y} end)
  end
end
