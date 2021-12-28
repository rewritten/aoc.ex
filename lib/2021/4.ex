defmodule Aoc.GiantSquid do
  def parse(text) do
    [nums | boards] = String.split(text, "\n\n", trim: true)
    nums = nums |> String.split(",") |> Enum.map(&String.to_integer/1)
    boards = Enum.map(boards, &parse_board/1)

    Stream.transform(nums, boards, &call_num/2)
  end

  def part_1(game) do
    {just_called, winner} = Enum.at(game, 0)
    just_called * (winner |> Enum.reduce(&MapSet.union/2) |> Enum.sum())
  end

  def part_2(game) do
    {just_called, loser} = game |> Enum.to_list() |> List.last(0)
    just_called * (loser |> Enum.reduce(&MapSet.union/2) |> Enum.sum())
  end

  defp parse_board(str) do
    rows = str |> String.split() |> Enum.map(&String.to_integer/1) |> Enum.chunk_every(5)
    cols = Enum.zip_with(rows, & &1)
    Enum.map(cols ++ rows, &MapSet.new/1)
  end

  defp call_num(called, boards) do
    {winners, playing} =
      boards
      |> Enum.map(fn board -> Enum.map(board, &MapSet.delete(&1, called)) end)
      |> Enum.split_with(fn board -> Enum.any?(board, &Enum.empty?/1) end)

    result = for board <- winners, do: {called, board}

    {result, playing}
  end
end
