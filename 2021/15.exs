#! /usr/bin/env elixir

for {reps, label} <- [{1, "part 1"}, {5, "part 2"}] do
  map =
    for {line, i} <- "input/2021/15.txt" |> File.read!() |> String.split() |> Enum.with_index(),
        {c, j} <- line |> String.to_charlist() |> Enum.with_index(),
        mi <- 0..(reps - 1),
        mj <- 0..(reps - 1),
        into: %{} do
      {{i + 100 * mi, j + 100 * mj}, rem(c - ?0 + mi + mj - 1, 9) + 1}
    end

  target = map |> Map.keys() |> Enum.max()

  Stream.unfold({%{0 => :queue.from_list([{0, 0}])}, MapSet.new()}, fn {prio, visited} ->
    distance = prio |> Map.keys() |> Enum.min()
    queue_to_check = prio |> Map.get(distance)
    {{:value, place}, rest} = :queue.out(queue_to_check)

    prio =
      if :queue.is_empty(rest),
        do: Map.delete(prio, distance),
        else: Map.put(prio, distance, rest)

    if MapSet.member?(visited, place) do
      {nil, {prio, visited}}
    else
      visited = MapSet.put(visited, place)
      {x, y} = place

      prio =
        for {i, j} <- [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}],
            w = Map.get(map, {i, j}),
            !MapSet.member?(visited, {i, j}),
            reduce: prio do
          prio ->
            Map.update(prio, distance + w, :queue.from_list([{i, j}]), &:queue.in({i, j}, &1))
        end

      {{place, distance}, {prio, visited}}
    end
  end)
  |> Enum.find(&match?({^target, _}, &1))
  |> elem(1)
  |> IO.inspect(label: label)
end
