#! /usr/bin/env elixir

# Use graph isomorphisms.
digits =
  ['abcefg', 'cf', 'acdeg', 'acdfg', 'bcdf', 'abdfg', 'abdefg', 'acf', 'abcdefg', 'abcdfg']
  |> Enum.map(&MapSet.new/1)

subsets = Enum.map(digits, fn digit -> Enum.count(digits, &MapSet.subset?(&1, digit)) end)
supersets = Enum.map(digits, fn digit -> Enum.count(digits, &MapSet.subset?(digit, &1)) end)

orig =
  [subsets, supersets, 0..9]
  |> Enum.zip_with(fn [sub, sup, i] -> {{sub, sup}, i} end)
  |> Map.new()

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

    Map.get(orig, {subsets, supersets})
  end)
  |> Integer.undigits()
end)
|> Enum.sum()
|> IO.inspect(label: "part 2")
