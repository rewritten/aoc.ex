#! /usr/bin/env elixir

[nums | boards] = "input/2021/4.txt" |> File.read!() |> String.split("\n\n", trim: true)

boards =
  for board <- boards do
    board = board |> String.split() |> Enum.map(&String.to_integer/1)
    rows = Enum.chunk_every(board, 5)
    cols = Enum.zip_with(rows, & &1)
    Enum.map(cols ++ rows, &MapSet.new/1)
  end

{game, _} =
  nums
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)
  |> Enum.flat_map_reduce(boards, fn n, boards ->
    boards = for b <- boards, do: for(line <- b, do: MapSet.delete(line, n))
    {winners, playing} = Enum.split_with(boards, fn board -> Enum.any?(board, &Enum.empty?/1) end)
    {for(w <- winners, do: {n, w}), playing}
  end)

{played, winner} = hd(game)

winner
|> Enum.reduce(&MapSet.union/2)
|> Enum.sum()
|> Kernel.*(played)
|> IO.inspect(label: "part 1")

{played, loser} = List.last(game)

loser
|> Enum.reduce(&MapSet.union/2)
|> Enum.sum()
|> Kernel.*(played)
|> IO.inspect(label: "part 2")
