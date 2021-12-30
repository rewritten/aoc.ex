defmodule Aoc.HydrothermalVenture do
  def solve(1, input) do
    for [a, b, c, d] = limits <- Input.l(input, map: :i),
        a == c or b == d,
        z <- diag(limits),
        reduce: {MapSet.new(), MapSet.new()} do
      {seen, again} ->
        if MapSet.member?(seen, z),
          do: {seen, MapSet.put(again, z)},
          else: {MapSet.put(seen, z), again}
    end
    |> elem(1)
    |> MapSet.size()
  end

  def solve(2, input) do
    for limits <- Input.l(input, map: :i),
        z <- diag(limits),
        reduce: {MapSet.new(), MapSet.new()} do
      {seen, again} ->
        if MapSet.member?(seen, z),
          do: {seen, MapSet.put(again, z)},
          else: {MapSet.put(seen, z), again}
    end
    |> elem(1)
    |> MapSet.size()
  end

  defp diag([a, b, a, d]), do: Enum.map(b..d, &{a, &1})
  defp diag([a, b, c, b]), do: Enum.map(a..c, &{&1, b})
  defp diag([a, b, c, d]), do: Enum.zip(a..c, b..d)
end
