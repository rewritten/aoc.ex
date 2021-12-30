defmodule Aoc.Amphipod do
  def solve(1, data) do
    data
    |> Input.sparse_matrix(&if(&1 in ?A..?D, do: {&1, 0}))
    |> Dijkstra.shortest_path(fn pos -> neighbors(pos, 3..2) end, &finish/1)
    |> elem(0)
  end

  def solve(2, data) do
    data
    |> String.split("\n")
    |> List.insert_at(3, "  #D#C#B#A#")
    |> List.insert_at(4, "  #D#B#A#C#")
    |> Enum.join("\n")
    |> Input.sparse_matrix(&if(&1 in ?A..?D, do: {&1, 0}))
    |> Dijkstra.shortest_path(fn pos -> neighbors(pos, 5..2) end, &finish/1)
    |> elem(0)
  end

  # def move_one(amphipod_type, from, other_amphipods, levels)

  # Blocked in room, cannot go up
  defp move_one(_, {d, j}, other, _) when is_map_key(other, {d - 1, j}), do: []

  # In hallway: move to final room
  defp move_one(type, {1, lat}, other, levels) do
    room = room_for(type)

    with _obstacles = [] <- for({{1, y}, _} <- other, y in lat..room, do: y),
         spaces =
           levels
           |> Enum.map(&Map.get(other, {&1, room}))
           |> Enum.drop_while(&match?({^type, _}, &1)),
         true <- Enum.all?(spaces, &is_nil/1) do
      [{1 + length(spaces), room}]
    else
      _ -> []
    end
  end

  # In room: move to hallway
  defp move_one(_, {_, room}, other, _) do
    left = for {{1, y}, _} <- other, y < room, reduce: 0, do: (acc -> max(acc, y))
    right = for {{1, y}, _} <- other, y > room, reduce: 12, do: (acc -> min(acc, y))

    for rest <- [1, 2, 4, 6, 8, 10, 11], rest > left, rest < right, do: {1, rest}
  end

  defp room_for(?A), do: 3
  defp room_for(?B), do: 5
  defp room_for(?C), do: 7
  defp room_for(?D), do: 9

  defp taxi_distance({a, b}, {x, y}), do: abs(x - a) + abs(y - b)

  defp neighbors(current, levels) do
    for {from, {letter, moves}} <- current,
        moves < 2,
        others = Map.delete(current, from),
        unit_cost = 10 ** (letter - ?A),
        dest <- move_one(letter, from, others, levels),
        distance = taxi_distance(from, dest),
        do: {Map.put(others, dest, {letter, moves + 1}), distance * unit_cost}
  end

  defp finish({_, pos}) when is_map_key(pos, {1, 1}), do: false
  defp finish({_, pos}) when is_map_key(pos, {1, 2}), do: false
  defp finish({_, pos}) when is_map_key(pos, {1, 4}), do: false
  defp finish({_, pos}) when is_map_key(pos, {1, 6}), do: false
  defp finish({_, pos}) when is_map_key(pos, {1, 8}), do: false
  defp finish({_, pos}) when is_map_key(pos, {1, 10}), do: false
  defp finish({_, pos}) when is_map_key(pos, {1, 11}), do: false
  defp finish(_), do: true
end
