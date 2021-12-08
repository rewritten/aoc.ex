#! /usr/bin/env elixir

import Enum

numbers =
  "input/2021/1.txt"
  |> File.read!()
  |> String.split()
  |> map(&String.to_integer/1)

numbers
|> chunk_every(2, 1, :discard)
|> count(fn [x, y] -> y > x end)
|> IO.inspect(label: "part 1")

numbers
|> chunk_every(3, 1, :discard)
|> map(&sum/1)
|> chunk_every(2, 1, :discard)
|> count(fn [x, y] -> y > x end)
|> IO.inspect(label: "part 2")
