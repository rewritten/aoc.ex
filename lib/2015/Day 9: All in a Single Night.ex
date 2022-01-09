defmodule Aoc.AllInASingleNight do
  def solve(1, text), do: text |> path_lengths() |> Enum.min()
  def solve(2, text), do: text |> path_lengths() |> Enum.max()

  defp path_lengths(text) do
    distances =
      text
      |> Input.l(map: :i?, map: fn [from, _, to, dist] -> {MapSet.new([from, to]), dist} end)
      |> Map.new()

    distances
    |> Map.keys()
    |> Enum.reduce(&MapSet.union/2)
    |> Enum.to_list()
    |> Perm.permutations()
    |> Stream.map(fn path ->
      path
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn pair -> Map.get(distances, MapSet.new(pair)) end)
      |> Enum.sum()
    end)
  end
end
