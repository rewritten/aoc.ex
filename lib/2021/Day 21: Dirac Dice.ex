defmodule Aoc.DiracDice do
  def solve(1, text) do
    [pos0, pos1] = Input.l(text, map: :i, map: &List.last/1)
    initial = {pos0, pos1, _score0 = 0, _score1 = 0, _current_player = 0}

    1..100
    |> Stream.cycle()
    |> Stream.chunk_every(3)
    |> Stream.with_index(1)
    |> Stream.transform(initial, &score/2)
    |> Enum.at(0)
  end

  def solve(2, text) do
    [pos0, pos1] = Input.l(text, map: :i, map: &List.last/1)
    initial = {pos0, pos1, _score0 = 0, _score1 = 0, _current_player = 0}

    {%{initial => 1}, {_wins_for_0 = 0, _wins_for_1 = 0}}
    |> Stream.iterate(&multistep/1)
    |> Enum.find(&match?({boards, _} when map_size(boards) == 0, &1))
    |> then(fn {_, {win0, win1}} -> max(win0, win1) end)
  end

  # Emit a score if a play is winning
  defp score({[a, b, c], turn}, board) do
    case play(board, a + b + c) do
      {_, _, s0, s1, _} = b when s0 >= 1000 -> {[s1 * turn * 3], b}
      {_, _, s0, s1, _} = b when s1 >= 1000 -> {[s0 * turn * 3], b}
      b -> {[], b}
    end
  end

  # Transform the multiverse by playing all moves, with counts, and taking apart
  # the winning boards.
  defp multistep({multiverse, wins}) do
    for {board, count} <- multiverse, i <- 1..3, j <- 1..3, k <- 1..3, reduce: {%{}, wins} do
      {next_multiv, {win0, win1}} ->
        case play(board, i + j + k) do
          {_, _, score0, _, _} when score0 >= 21 -> {next_multiv, {win0 + count, win1}}
          {_, _, _, score1, _} when score1 >= 21 -> {next_multiv, {win0, win1 + count}}
          board -> {Map.update(next_multiv, board, count, &(&1 + count)), {win0, win1}}
        end
    end
  end

  defp play({pos0, pos1, score0, score1, _current_player = 0}, roll) do
    pos0 = rem(pos0 + roll + 9, 10) + 1
    {pos0, pos1, score0 + pos0, score1, 1}
  end

  defp play({pos0, pos1, score0, score1, _current_player = 1}, roll) do
    pos1 = rem(pos1 + roll + 9, 10) + 1
    {pos0, pos1, score0, score1 + pos1, 0}
  end
end
