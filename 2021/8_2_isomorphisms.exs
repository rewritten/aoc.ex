#! /usr/bin/env elixir

# Use graph isomorphisms.

"input/2021/8.txt"
|> File.read!()
|> String.split(~r"[^a-g]+", trim: true)
|> Enum.map(&(&1 |> String.to_charlist() |> MapSet.new()))
|> Enum.chunk_every(14)
|> Enum.map(fn line ->
  {digits, input} = Enum.split(line, 10)

  input
  |> Enum.map(fn digit ->
    subsets = Enum.count(digits, &MapSet.subset?(&1, digit))
    supersets = Enum.count(digits, &MapSet.subset?(digit, &1))

    case {subsets, supersets} do
      {3, 2} -> 0
      {1, 7} -> 1
      {1, 2} -> 2
      {3, 3} -> 3
      {2, 3} -> 4
      {1, 4} -> 5
      {2, 2} -> 6
      {2, 5} -> 7
      {10, 1} -> 8
      {6, 2} -> 9
    end
  end)
  |> Integer.undigits()
end)
|> Enum.sum()
|> IO.inspect(label: "part 2")
