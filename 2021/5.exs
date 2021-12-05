#! /usr/bin/env elixir

import Enum

data =
  "input/2021/5.txt"
  |> File.read!()
  |> String.split(~r([^\d]+), trim: true)
  |> map(&String.to_integer/1)
  |> chunk_every(4)

data
|> flat_map(fn
  [a, b, a, d] -> map(b..d, &{a, &1})
  [a, b, c, b] -> map(a..c, &{&1, b})
  _ -> []
end)
|> frequencies()
|> reject(&match?({_, 1}, &1))
|> count()
|> IO.inspect(label: "part 1")

data
|> flat_map(fn
  [a, b, a, d] -> map(b..d, &{a, &1})
  [a, b, c, b] -> map(a..c, &{&1, b})
  [a, b, c, d] -> zip(a..c, b..d)
end)
|> frequencies()
|> reject(&match?({_, 1}, &1))
|> count()
|> IO.inspect(label: "part 2")
