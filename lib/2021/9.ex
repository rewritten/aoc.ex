defmodule Aoc.SmokeBasin do
  def parse(text), do: Input.sparse_matrix(text, &(&1 - ?0), &(&1 != ?9))

  def part_1(data) do
    for {{i, j}, c} <- data,
        Map.get(data, {i, j + 1}, 9) > c,
        Map.get(data, {i, j - 1}, 9) > c,
        Map.get(data, {i + 1, j}, 9) > c,
        Map.get(data, {i - 1, j}, 9) > c,
        reduce: 0 do
      acc -> acc + c + 1
    end
  end

  def part_2(data) do
    {data, %{}, []}
    |> Stream.unfold(&flood/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&map_size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(&Kernel.*/2)
  end

  def flood({space, _, _}) when map_size(space) == 0, do: nil

  def flood({space, component, frontier}) do
    case Map.split(space, frontier) do
      {empty, _} when map_size(empty) == 0 ->
        {k, _} = Enum.at(space, 0)
        {component, {space, %{}, [k]}}

      {neighbors, rest} ->
        new_frontier =
          Enum.flat_map(neighbors, fn {{i, j}, _} ->
            [{i + 1, j}, {i - 1, j}, {i, j + 1}, {i, j - 1}]
          end)

        {nil, {rest, Map.merge(component, neighbors), new_frontier}}
    end
  end
end
