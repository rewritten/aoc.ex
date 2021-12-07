#! /usr/bin/env elixir

import Enum

data =
  "input/2021/7.txt"
  |> File.read!()
  |> String.split(~r([\D]+), trim: true)
  |> map(&String.to_integer/1)
  |> sort()

med = at(data, Integer.floor_div(count(data), 2) - 1)

data
|> map(&abs(&1 - med))
|> sum
|> IO.inspect(label: "Part 1")

avg = (sum(data) / count(data)) |> round()

(avg - 2)..(avg + 2)
|> map(fn x ->
  data
  |> map(&abs(&1 - x))
  |> map(&Integer.floor_div(&1 * (&1 + 1), 2))
  |> sum()
end)
|> min()
|> IO.inspect(label: "Part 2")
