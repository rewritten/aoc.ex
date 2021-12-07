#! /usr/bin/env elixir

data =
  "input/2021/6.txt"
  |> File.read!()
  |> String.to_charlist()
  |> Enum.frequencies()
  |> then(&for c <- ?0..?8, do: Map.get(&1, c, 0))
  |> Stream.iterate(fn [zero | rest] ->
    update_in(rest ++ [zero], [Access.at(6)], &(&1 + zero))
  end)

data
|> Enum.at(80)
|> Enum.sum()
|> IO.inspect(label: "part 1")

data
|> Enum.at(256)
|> Enum.sum()
|> IO.inspect(label: "part 2")
