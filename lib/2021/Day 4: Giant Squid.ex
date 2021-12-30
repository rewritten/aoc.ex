defmodule Aoc.GiantSquid do
  def solve(1, input) do
    game = parse(input)
    {just_called, winner} = Enum.at(game, 0)
    just_called * (winner |> Enum.reduce(&MapSet.union/2) |> Enum.sum())
  end

  def solve(2, input) do
    game = parse(input)
    {just_called, loser} = game |> Enum.to_list() |> List.last(0)
    just_called * (loser |> Enum.reduce(&MapSet.union/2) |> Enum.sum())
  end

  defp parse(text) do
    [nums | boards] = Input.p(text)
    nums = Input.i(nums)
    boards = Enum.map(boards, &parse_board/1)

    Stream.transform(nums, boards, &call_num/2)
  end

  defp parse_board(str) do
    rows = Input.l(str, map: :i)
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
