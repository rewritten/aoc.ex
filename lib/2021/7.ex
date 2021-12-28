defmodule Aoc.TheTreacheryOfWhales do
  def parse(text) do
    text
    |> String.split(~r([\D]+), trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end

  def part_1(data) do
    count = Enum.count(data)
    delta = fn pos -> 2 * Enum.find_index(data, &(&1 >= pos)) - count end

    1..List.last(data)
    |> Stream.transform(Enum.sum(data), fn pos, cost -> {[cost], cost + delta.(pos)} end)
    |> Enum.min()
  end

  def part_2(data) do
    initial_cost = data |> Enum.map(&div(&1 * (&1 + 1), 2)) |> Enum.sum()
    sum = Enum.sum(data)
    count = Enum.count(data)
    delta = fn pos -> (pos - 1) * count + Enum.find_index(data, &(&1 >= pos)) - sum end

    1..List.last(data)
    |> Stream.transform(initial_cost, fn pos, cost -> {[cost], cost + delta.(pos)} end)
    |> Enum.min()
  end
end
