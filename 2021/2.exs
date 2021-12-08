#! /usr/bin/env elixir

"input/2021/2.txt"
|> File.read!()
|> String.split()
|> Enum.chunk_every(2)
|> Enum.map(fn [d, n] -> [d, String.to_integer(n)] end)
|> Enum.reduce([0, 0], fn
  ["up", n], [hor, dep] -> [hor, dep - n]
  ["down", n], [hor, dep] -> [hor, dep + n]
  ["forward", n], [hor, dep] -> [hor + n, dep]
end)
|> then(fn [hor, dep] -> hor * dep end)
|> IO.inspect(label: "part 1")

"input/2021/2.txt"
|> File.read!()
|> String.split()
|> Enum.chunk_every(2)
|> Enum.map(fn [d, n] -> [d, String.to_integer(n)] end)
|> Enum.reduce([0, 0, 0], fn
  ["up", n], [hor, dep, aim] -> [hor, dep, aim - n]
  ["down", n], [hor, dep, aim] -> [hor, dep, aim + n]
  ["forward", n], [hor, dep, aim] -> [hor + n, dep + aim * n, aim]
end)
|> then(fn [hor, dep, _] -> hor * dep end)
|> IO.inspect(label: "part 2")
