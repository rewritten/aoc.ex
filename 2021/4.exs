#! /usr/bin/env elixir

import Enum

[nums | boards] = "input/2021/4.txt" |> File.read!() |> String.split("\n\n", trim: true)

nums =
  nums
  |> String.split(",")
  |> map(&String.to_integer/1)

boards =
  map(boards, fn b ->
    b = b |> String.split() |> map(&String.to_integer/1)
    rows = chunk_every(b, 5)
    cols = zip_with(rows, & &1)
    map(cols ++ rows, &MapSet.new/1)
  end)

game =
  {nil, nums, boards, []}
  |> Stream.iterate(fn {_, [n | rest], boards, _} ->
    {new_winners, still_playing} =
      boards
      |> map(fn board -> map(board, fn line -> MapSet.delete(line, n) end) end)
      |> split_with(fn board -> any?(board, &empty?/1) end)

    {n, rest, still_playing, new_winners}
  end)
  |> Stream.reject(&match?({_, _, _, []}, &1))

{nxt, _, _, [winner]} = at(game, 1)

winner
|> reduce(&MapSet.union/2)
|> sum()
|> then(&(&1 * nxt))
|> IO.inspect(label: "part 1")

{nxt, _, _, [loser]} = find(game, &match?({_, _, [], _}, &1))

loser
|> reduce(&MapSet.union/2)
|> sum()
|> then(&(&1 * nxt))
|> IO.inspect(label: "part 2")
