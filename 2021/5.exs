#! /usr/bin/env elixir

"input/2021/5.txt"
|> File.read!()
|> String.split(~r([^\d]+), trim: true)
|> Enum.map(&String.to_integer/1)
|> Enum.chunk_every(4)
|> Enum.flat_map(fn
  [a, b, a, d] -> Enum.map(b..d, &{a, &1})
  [a, b, c, b] -> Enum.map(a..c, &{&1, b})
  _ -> []
end)
|> Enum.frequencies()
|> Enum.count(&(!match?({_, 1}, &1)))
|> IO.inspect(label: "part 1")

"input/2021/5.txt"
|> File.read!()
|> String.split(~r([^\d]+), trim: true)
|> Enum.map(&String.to_integer/1)
|> Enum.chunk_every(4)
|> Enum.flat_map(fn
  [a, b, a, d] -> Enum.map(b..d, &{a, &1})
  [a, b, c, b] -> Enum.map(a..c, &{&1, b})
  [a, b, c, d] -> Enum.zip(a..c, b..d)
end)
|> Enum.frequencies()
|> Enum.count(&(!match?({_, 1}, &1)))
|> IO.inspect(label: "part 2")
