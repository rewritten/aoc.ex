#! /usr/bin/env elixir

data =
  "input/2021/6.txt"
  |> File.read!()
  |> String.to_charlist()
  |> Enum.frequencies()
  |> then(&for c <- ?0..?8, do: Map.get(&1, c, 0))
  |> Stream.iterate(fn [a, b, c, d, e, f, g, h, i] -> [b, c, d, e, f, g, h + a, i, a] end)

data
|> Enum.at(80)
|> Enum.sum()
|> IO.inspect(label: "part 1")

data
|> Enum.at(256)
|> Enum.sum()
|> IO.inspect(label: "part 2")
