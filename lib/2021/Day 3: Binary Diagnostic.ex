defmodule Aoc.BinaryDiagnostic do
  def solve(1, input) do
    input
    |> Input.matrix(&(&1 - ?0))
    |> Enum.zip_with(& &1)
    |> Enum.map(fn col ->
      %{0 => zeroes, 1 => ones} = Enum.frequencies(col)
      if ones >= zeroes, do: [1, 0], else: [0, 1]
    end)
    |> Enum.zip_with(& &1)
    |> Enum.map(&Integer.undigits(&1, 2))
    |> then(fn [e, d] -> e * d end)
  end

  def solve(2, input) do
    input
    |> Input.matrix(&(&1 - ?0))
    |> then(&{&1, &1})
    |> Stream.unfold(fn {lows, highs} ->
      {low, new_lows} =
        lows |> Enum.group_by(&hd/1, &tl/1) |> Enum.min_by(fn {k, v} -> {length(v), k} end)

      {high, new_highs} =
        highs |> Enum.group_by(&hd/1, &tl/1) |> Enum.max_by(fn {k, v} -> {length(v), k} end)

      {[low, high], {new_lows, new_highs}}
    end)
    |> Enum.take(12)
    |> Enum.zip_with(& &1)
    |> Enum.map(&Integer.undigits(&1, 2))
    |> then(fn [e, d] -> e * d end)
  end
end
