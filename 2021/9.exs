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
|> IO.inspect()
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
