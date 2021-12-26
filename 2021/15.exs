#! /usr/bin/env elixir

Code.require_file("lib/dijkstra.ex")
Code.require_file("lib/input.ex")

input = File.read!("input/2021/15.txt")
data = Input.sparse_matrix(input, &(&1 - ?0))

for {reps, label} <- [{1, "part 1"}, {5, "part 2"}] do
  map =
    for {{i, j}, c} <- data,
        mi <- 0..(reps * 100 - 1)//100,
        mj <- 0..(reps * 100 - 1)//100,
        into: %{},
        do: {{i + mi, j + mj}, rem(c + mi + mj - 1, 9) + 1}

  target = map |> Map.keys() |> Enum.max()

  {cost, _} =
    DijkstraEts.shortest_path(
      {0, 0},
      fn {x, y} ->
        map
        |> Map.take([{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}])
        |> Enum.map(fn {pos, cost} -> {cost, pos} end)
      end,
      &match?({_, ^target}, &1)
    )

  IO.inspect(cost, label: label)
end
