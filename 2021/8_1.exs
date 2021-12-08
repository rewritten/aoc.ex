#! /usr/bin/env elixir

"input/2021/8.txt"
|> File.read!()
|> String.split(~r"[^a-g]+", trim: true)
|> Enum.drop(10)
|> Enum.chunk_every(4, 14, :discard)
|> List.flatten()
|> Enum.count(&(String.length(&1) in [2, 3, 4, 7]))
|> IO.inspect(label: "part 1")
