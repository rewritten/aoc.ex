#! /usr/bin/env elixir

import Enum

bits =
  "2021/3.txt"
  |> File.stream!()
  |> map(fn line -> line |> String.trim() |> String.to_charlist() end)

bits
|> then(fn l -> l |> zip() |> map(&Tuple.to_list/1) end)
|> map(fn col ->
  # '0101100101001...' (list of chars)
  col
  # %{?0 => 42, ?1 => 58}
  |> frequencies()
  # [{?0, 42}, {?1, 58}]
  |> sort_by(fn {_, v} -> v end)
  # [?0, ?1]
  |> map(fn {k, _} -> k end)
end)
|> then(fn l -> l |> zip() |> map(&Tuple.to_list/1) end)
|> map(&:erlang.list_to_integer(&1, 2))
|> then(fn [e, d] -> e * d end)
|> IO.inspect(label: "part 1")

comparison_fn = fn {k, v} -> {count(v), k} end

Stream.resource(
  fn -> {bits, bits} end,
  fn
    {[[] | _], _} ->
      {:halt, nil}

    {lows, highs} ->
      {low, new_lows} = lows |> group_by(&hd/1, &tl/1) |> min_by(comparison_fn)
      {high, new_highs} = highs |> group_by(&hd/1, &tl/1) |> max_by(comparison_fn)

      {[[low, high]], {new_lows, new_highs}}
  end,
  fn _ -> nil end
)
|> to_list()
|> then(fn l -> l |> zip() |> map(&Tuple.to_list/1) end)
|> map(&:erlang.list_to_integer(&1, 2))
|> then(fn [e, d] -> e * d end)
|> IO.inspect(label: "part 2")
