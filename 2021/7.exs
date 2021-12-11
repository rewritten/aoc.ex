#! /usr/bin/env elixir

data =
  "input/2021/7.txt"
  |> File.read!()
  |> String.split(~r([\D]+), trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.sort()

# Check optimal value around median
data
|> Enum.at(div(length(data), 2) - 1)
|> then(&[&1, &1 + 1])
|> Enum.map(fn x ->
  data
  |> Enum.map(&abs(&1 - x))
  |> Enum.sum()
end)
|> Enum.min()
|> IO.inspect(label: "Part 1")

# Check optimal value around average
data
|> Enum.sum()
|> div(length(data))
|> then(&[&1, &1 + 1])
|> Enum.map(fn x ->
  data
  |> Enum.map(&div(abs(&1 - x) * (abs(&1 - x) + 1), 2))
  |> Enum.sum()
end)
|> Enum.min()
|> IO.inspect(label: "Part 2")
