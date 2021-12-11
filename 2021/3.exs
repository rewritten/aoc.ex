#! /usr/bin/env elixir

data =
  "input/2021/3.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_charlist/1)

data
|> Enum.zip_with(& &1)
|> Enum.map(fn col ->
  col |> Enum.frequencies() |> Enum.sort_by(fn {_, v} -> v end) |> Enum.map(fn {k, _} -> k end)
end)
|> Enum.zip_with(& &1)
|> Enum.map(&:erlang.list_to_integer(&1, 2))
|> then(fn [e, d] -> e * d end)
|> IO.inspect(label: "part 1")

data
|> then(&fn -> {&1, &1} end)
|> Stream.resource(
  fn {lows, highs} ->
    {low, new_lows} =
      lows |> Enum.group_by(&hd/1, &tl/1) |> Enum.min_by(fn {k, v} -> {length(v), k} end)

    {high, new_highs} =
      highs |> Enum.group_by(&hd/1, &tl/1) |> Enum.max_by(fn {k, v} -> {length(v), k} end)

    {[[low, high]], {new_lows, new_highs}}
  end,
  fn _ -> nil end
)
|> Enum.take(12)
|> Enum.zip_with(& &1)
|> Enum.map(&:erlang.list_to_integer(&1, 2))
|> then(fn [e, d] -> e * d end)
|> IO.inspect(label: "part 2")
