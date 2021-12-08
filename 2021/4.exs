#! /usr/bin/env elixir

[nums | boards] = "input/2021/4.txt" |> File.read!() |> String.split("\n\n", trim: true)

nums =
  nums
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

boards =
  for board <- boards do
    board = board |> String.split() |> Enum.map(&String.to_integer/1)
    rows = Enum.chunk_every(board, 5)
    cols = Enum.zip_with(rows, & &1)
    Enum.map(cols ++ rows, &MapSet.new/1)
  end

game =
  {nums, boards, nil, []}
  |> Stream.iterate(fn {[number | rest], playing, _last_played, _last_winners} ->
    playing =
      for board <- playing do
        for line <- board, do: MapSet.delete(line, number)
      end

    {new_winners, still_playing} =
      Enum.split_with(playing, fn board -> Enum.any?(board, &Enum.empty?/1) end)

    {rest, still_playing, number, new_winners}
  end)

{_, _, played, [winner]} = Enum.find(game, &match?({_, _, _, [_]}, &1))

winner
|> Enum.reduce(&MapSet.union/2)
|> Enum.sum()
|> Kernel.*(played)
|> IO.inspect(label: "part 1")

{_, _, played, [loser]} = Enum.find(game, &match?({_, [], _, [_]}, &1))

loser
|> Enum.reduce(&MapSet.union/2)
|> Enum.sum()
|> Kernel.*(played)
|> IO.inspect(label: "part 2")
