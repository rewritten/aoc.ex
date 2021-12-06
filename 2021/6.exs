#! /usr/bin/env elixir

data =
  "input/2021/6.txt"
  |> File.read!()
  |> String.trim()
  |> String.to_charlist()
  |> Enum.frequencies()

gens = for c <- ?0..?8, do: Map.get(data, c, 0)

1..80
|> Enum.reduce(gens, fn _, [z | rest] ->
  update_in(rest ++ [z], [Access.at(6)], &(&1 + z))
end)
|> Enum.sum()
|> IO.inspect(label: "part 1")

1..256
|> Enum.reduce(gens, fn _, [z | rest] ->
  update_in(rest ++ [z], [Access.at(6)], &(&1 + z))
end)
|> Enum.sum()
|> IO.inspect(label: "part 2")
