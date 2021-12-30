defmodule Aoc.ExtendedPolymerization do
  def solve(1, input), do: input |> parse() |> run(10)
  def solve(2, input), do: input |> parse() |> run(40)

  defp parse(text) do
    [initial, replacement_data] = Input.p(text)

    for [pair, insertion] <- Input.l(replacement_data, map: :w) do
      Cache.fetch(pair, fn -> insertion end)
    end

    String.to_charlist(initial)
  end

  defp run(initial, iterations) do
    {min, max} =
      initial
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&counts(&1, iterations))
      |> Enum.reduce(%{List.last(initial) => 1}, &Map.merge(&1, &2, fn _k, v1, v2 -> v1 + v2 end))
      |> Map.values()
      |> Enum.min_max()

    max - min
  end

  defp counts([l, _], 0), do: %{l => 1}

  defp counts([l, r], level) do
    Cache.fetch({[l, r], level}, fn ->
      <<inter>> = Cache.fetch(<<l, r>>)
      left = counts([l, inter], level - 1)
      right = counts([inter, r], level - 1)
      Map.merge(left, right, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end
end
