#! /usr/bin/env elixir

"input/2021/8.txt"
|> File.read!()
|> String.split(~r"[^a-g]+", trim: true)
|> Enum.chunk_every(14)
|> Enum.map(&Enum.drop(&1, 10))
|> List.flatten()
|> Enum.map(&String.length/1)
|> Enum.frequencies()
|> then(&(Map.get(&1, 2, 0) + Map.get(&1, 3, 0) + Map.get(&1, 4, 0) + Map.get(&1, 7, 0)))
|> IO.inspect(label: "part 1")
