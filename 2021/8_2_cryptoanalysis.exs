#! /usr/bin/env elixir

# Use frequency analysis to find the transposition key
digits = ['abcefg', 'cf', 'acdeg', 'acdfg', 'bcdf', 'abdfg', 'abdefg', 'acf', 'abcdefg', 'abcdfg']
freqs = digits |> List.flatten() |> Enum.frequencies()

orig =
  digits
  |> Enum.map(fn d -> d |> Enum.map(&Map.get(freqs, &1)) |> Enum.sort() end)
  |> Enum.with_index()
  |> Map.new()

"input/2021/8.txt"
|> File.read!()
|> String.split(~r"[^a-g]+", trim: true)
|> Enum.map(&String.to_charlist/1)
|> Enum.chunk_every(14)
|> Enum.map(fn line ->
  {digits, input} = Enum.split(line, 10)
  freqs = digits |> List.flatten() |> Enum.frequencies()

  input
  |> Enum.map(fn d -> d |> Enum.map(&Map.get(freqs, &1)) |> Enum.sort() end)
  |> Enum.map(&Map.get(orig, &1))
  |> Integer.undigits()
end)
|> Enum.sum()
|> IO.inspect(label: "part 2")
