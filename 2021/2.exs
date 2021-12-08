#! /usr/bin/env elixir

directions =
  "2021/2.txt"
  |> File.stream!()
  |> Stream.map(fn line ->
    line
    |> String.split()
    |> update_in([Access.at(1)], &String.to_integer/1)
  end)

directions
|> Enum.reduce([0, 0], fn
  ["up", n], [hor, dep] -> [hor, dep - n]
  ["down", n], [hor, dep] -> [hor, dep + n]
  ["forward", n], [hor, dep] -> [hor + n, dep]
end)
|> then(fn [hor, dep] -> hor * dep end)
|> IO.inspect(label: "part 1")

directions
|> Enum.reduce([0, 0, 0], fn
  ["up", n], [hor, dep, aim] -> [hor, dep, aim - n]
  ["down", n], [hor, dep, aim] -> [hor, dep, aim + n]
  ["forward", n], [hor, dep, aim] -> [hor + n, dep + aim * n, aim]
end)
|> then(fn [hor, dep, _] -> hor * dep end)
|> IO.inspect(label: "part 2")
