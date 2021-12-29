defmodule Aoc.TheTreacheryOfWhales do
  def solve(1, input) do
    data = parse(input)
    count = Enum.count(data)

    optimal(1..List.last(data), Enum.sum(data), fn pos ->
      # crabs to the left increase cost by 1
      # crabs to the right decrease cost by 1
      to_the_left = Enum.find_index(data, &(&1 >= pos))
      to_the_right = count - to_the_left
      to_the_left - to_the_right
    end)
  end

  def solve(2, input) do
    data = parse(input)
    initial_cost = data |> Enum.map(&div(&1 * (&1 + 1), 2)) |> Enum.sum()
    sum = Enum.sum(data)
    count = Enum.count(data)

    optimal(1..List.last(data), initial_cost, fn target ->
      # crabs to the left increase cost by their current distance (= target - crab position)
      # crabs to the right decrease cost by their previous distance (= crab position - target + 1)
      # Changing sign and adding up, we can simplify to:
      to_the_left = Enum.find_index(data, &(&1 >= target))
      to_the_right = count - to_the_left
      count * target - sum - to_the_right
    end)
  end

  defp parse(text) do
    text
    |> String.split(~r([\D]+), trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end

  defp optimal(range, initial, delta_fn) do
    range
    |> Stream.transform(initial, fn pos, cost -> {[cost], cost + delta_fn.(pos)} end)
    |> Enum.min()
  end
end
