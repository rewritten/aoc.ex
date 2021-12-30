defmodule Aoc.PerfectlySphericalHousesInAVacuum do
  def solve(1, text) do
    text
    |> String.trim()
    |> String.to_charlist()
    |> visited()
    |> MapSet.size()
  end

  def solve(2, text) do
    [a, b] =
      text
      |> String.trim()
      |> String.to_charlist()
      |> Enum.chunk_every(2)
      |> Enum.zip_with(& &1)

    MapSet.union(visited(a), visited(b))
    |> MapSet.size()
  end

  defp visited(path) do
    path
    |> Stream.transform({0, 0}, fn
      ?^, {x, y} -> {[{x, y + 1}], {x, y + 1}}
      ?>, {x, y} -> {[{x + 1, y}], {x + 1, y}}
      ?v, {x, y} -> {[{x, y - 1}], {x, y - 1}}
      ?<, {x, y} -> {[{x - 1, y}], {x - 1, y}}
    end)
    |> MapSet.new()
    |> MapSet.put({0, 0})
  end
end
