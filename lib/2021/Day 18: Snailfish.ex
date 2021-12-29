#! /usr/bin/env elixir
defmodule Aoc.Snailfish do
  def solve(1, input) do
    input
    |> String.split()
    |> Enum.map(&(&1 |> Code.eval_string() |> elem(0)))
    |> Enum.reduce(fn a, b -> reduce([b, a]) end)
    |> magnitude()
  end

  def solve(2, input) do
    numbers = input |> String.split() |> Enum.map(&(&1 |> Code.eval_string() |> elem(0)))
    pairwise = for i <- numbers, j <- numbers, i != j, do: [i, j] |> reduce() |> magnitude()
    Enum.max(pairwise)
  end

  defp reduce(term) do
    with ^term <- explode(term), ^term <- split(term) do
      term
    else
      changed -> reduce(changed)
    end
  end

  defp magnitude([left, right]), do: 3 * magnitude(left) + 2 * magnitude(right)
  defp magnitude(n), do: n

  defp explode(term), do: term |> explode(0) |> elem(1)

  defp explode(n, _) when is_integer(n), do: {0, n, 0}
  defp explode([left, right], 4), do: {left, 0, right}

  defp explode(pair, n) do
    explode_left(pair, n) || explode_right(pair, n) || {0, pair, 0}
  end

  defp explode_left([left, right], n) do
    {spill_left, changed, spill_right} = explode(left, n + 1)
    if changed != left, do: {spill_left, [changed, add(spill_right, right)], 0}
  end

  defp explode_right([left, right], n) do
    {spill_left, changed, spill_right} = explode(right, n + 1)
    if changed != right, do: {0, [add(left, spill_left), changed], spill_right}
  end

  defp add(n, [left, right]), do: [add(n, left), right]
  defp add([left, right], n), do: [left, add(right, n)]
  defp add(left, right), do: left + right

  defp split([left, right]) do
    case split(left) do
      ^left -> [left, split(right)]
      other -> [other, right]
    end
  end

  defp split(n) when n > 9, do: [div(n, 2), n - div(n, 2)]
  defp split(n), do: n
end
