#! /usr/bin/env elixir

data =
  "input/2021/1.txt"
  |> File.read!()
  |> String.split()
  |> Enum.map(&String.to_integer/1)

data
|> Enum.chunk_every(2, 1, :discard)
|> Enum.count(fn [x, y] -> y > x end)
|> IO.inspect(label: "part 1")

data
|> Enum.chunk_every(3, 1, :discard)
|> Enum.map(&Enum.sum/1)
|> Enum.chunk_every(2, 1, :discard)
|> Enum.count(fn [x, y] -> y > x end)
|> IO.inspect(label: "part 2")
