#! /usr/bin/env elixir

"input/2021/9.txt"
|> File.read!()
|> String.split()
|> Enum.map(
  &(Stream.cycle([?_ | String.to_charlist(&1)])
    |> Stream.chunk_every(3, 1)
    |> Enum.take(100))
)
|> List.insert_at(0, Stream.cycle([[?_, ?_, ?_]]))
|> Stream.cycle()
|> Stream.chunk_every(3, 1)
|> Enum.take(100)
|> Enum.flat_map(fn triple ->
  triple
  |> Enum.zip()
  |> Enum.flat_map(fn
    {[_, u, _], [l, o, r], [_, d, _]} when o < d and o < u and o < r and o < l -> [o - ?0 + 1]
    _ -> []
  end)
end)
|> Enum.sum()
|> IO.inspect(label: "part 1")

"input/2021/9.txt"
|> File.read!()
|> String.split()
|> Enum.with_index(fn line, i ->
  line
  |> String.to_charlist()
  |> Enum.with_index(fn
    ?9, _ -> []
    _, j -> {i, j}
  end)
end)
|> List.flatten()
|> then(&%{space: &1, basins: [], queue: []})
|> Stream.iterate(fn
  %{space: []} = input ->
    input

  %{space: [{x, y} = p | rest], basins: basins, queue: []} ->
    basins = [[p] | basins]
    queue = [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    %{space: rest, basins: basins, queue: queue}

  %{space: space, basins: [cur | oth], queue: [p | rest]} ->
    if p in space do
      {x, y} = p

      %{
        space: space -- [p],
        basins: [[p | cur] | oth],
        queue: rest ++ [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
      }
    else
      %{space: space, basins: [cur | oth], queue: rest}
    end
end)
|> Enum.find(&match?(%{space: []}, &1))
|> Map.get(:basins)
|> Enum.map(&length/1)
|> Enum.sort(&Kernel.>=/2)
|> Enum.take(3)
|> Enum.reduce(&Kernel.*/2)
|> IO.inspect(label: "part 2")
