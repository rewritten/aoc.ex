#! /usr/bin/env elixir

{pos0, pos1} =
  "input/2021/21.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn s -> s |> String.split() |> List.last() |> String.to_integer() end)
  |> List.to_tuple()

# Board structure:
# {position of 0, position of 1, score of 0, score of 1, current player}
initial = {pos0, pos1, 0, 0, 0}

# given a board and a roll (already summed), returns the new board
play = fn
  {pos0, pos1, score0, score1, 0}, roll ->
    pos0 = rem(pos0 + roll + 9, 10) + 1
    {pos0, pos1, score0 + pos0, score1, 1}

  {pos0, pos1, score0, score1, 1}, roll ->
    pos1 = rem(pos1 + roll + 9, 10) + 1
    {pos0, pos1, score0, score1 + pos1, 0}
end

1..100
|> Stream.cycle()
|> Stream.chunk_every(3)
|> Stream.transform(initial, fn [a, b, c], board ->
  played = play.(board, a + b + c)
  {[played], played}
end)
|> Stream.with_index()
|> Enum.find(&match?({{_, _, score0, score1, _}, _} when score0 >= 1000 or score1 >= 1000, &1))
|> then(fn {{_, _, score0, score1, _}, turns} -> min(score0, score1) * turns * 3 end)
|> IO.inspect(label: "part 1")

{%{initial => 1}, {0, 0}}
|> Stream.iterate(fn {multiverse, wins} ->
  for {board, count} <- multiverse, i <- 1..3, j <- 1..3, k <- 1..3, reduce: {%{}, wins} do
    {next_multiv, {win0, win1}} ->
      case play.(board, i + j + k) do
        {_, _, score0, _, _} when score0 >= 21 -> {next_multiv, {win0 + count, win1}}
        {_, _, _, score1, _} when score1 >= 21 -> {next_multiv, {win0, win1 + count}}
        board -> {Map.update(next_multiv, board, count, &(&1 + count)), {win0, win1}}
      end
  end
end)
|> Enum.find(&match?({boards, _} when map_size(boards) == 0, &1))
|> then(fn {_, {win0, win1}} -> max(win0, win1) end)
|> IO.inspect(label: "part 2")
