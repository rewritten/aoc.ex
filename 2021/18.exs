#! /usr/bin/env elixir

defmodule Snailfish do
  def reduce(term) do
    with ^term <- elem(explode(term, 0), 1), ^term <- split(term) do
      term
    else
      changed -> reduce(changed)
    end
  end

  def magn([left, right]), do: 3 * magn(left) + 2 * magn(right)
  def magn(n), do: n

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

  defp split(n) when is_integer(n) and n <= 9, do: n
  defp split(n) when is_integer(n), do: [div(n, 2), n - div(n, 2)]

  defp split([left, right]) do
    case split(left) do
      ^left -> [left, split(right)]
      other -> [other, right]
    end
  end
end

numbers =
  "input/2021/18.txt"
  |> File.read!()
  |> String.split()
  |> Enum.map(&(&1 |> Code.eval_string() |> elem(0)))

numbers
|> Enum.reduce(fn a, b -> Snailfish.reduce([b, a]) end)
|> Snailfish.magn()
|> IO.inspect(label: "part 1")

for i <- numbers, j <- numbers, i != j do
  [i, j] |> Snailfish.reduce() |> Snailfish.magn()
end
|> Enum.max()
|> IO.inspect(label: "part 2")
