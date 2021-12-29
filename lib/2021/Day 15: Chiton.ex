defmodule Aoc.Chiton do
  def solve(1, input), do: input |> Input.sparse_matrix(&(&1 - ?0)) |> find_path({99, 99})

  def solve(2, input) do
    data =
      for {{i, j}, c} <- Input.sparse_matrix(input, &(&1 - ?0)),
          mi <- 0..400//100,
          mj <- 0..400//100,
          value = rem(c + mi + mj, 9),
          value = if(value == 0, do: 9, else: value),
          into: %{},
          do: {{i + mi, j + mj}, value}

    find_path(data, {499, 499})
  end

  defp find_path(matrix, destination) do
    {cost, _} =
      Dijkstra.shortest_path(
        {0, 0},
        fn {x, y} -> Map.take(matrix, [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]) end,
        &match?({_, ^destination}, &1)
      )

    cost
  end
end
