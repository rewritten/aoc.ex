#! /usr/bin/env elixir

# Use frequency analysis to find the transposition key

import Enum

data =
  "input/2021/8.txt"
  |> File.read!()
  |> String.split(~r"[^a-g]+", trim: true)
  |> map(&String.to_charlist/1)
  |> chunk_every(14)

# original digits
orig = ['abcefg', 'cf', 'acdeg', 'acdfg', 'bcdf', 'abdfg', 'abdefg', 'acf', 'abcdefg', 'abcdfg']

# %{?a => 8, ?b => 6, ?c => 8, ?d => 7, ?e => 4, ?f => 9, ?g => 7}
expected_freqs = orig |> List.flatten() |> frequencies()

# Map of frequencies to original digit. For instance [8, 9] will map to 1
mapping =
  orig
  |> map(fn unkn -> unkn |> map(&Map.fetch!(expected_freqs, &1)) |> sort() end)
  |> with_index(fn element, index -> {element, index} end)
  |> Map.new()

data
|> map(fn line ->
  {digits, input} = split(line, 10)
  freqs = digits |> List.flatten() |> frequencies()

  input
  |> map(fn digit -> Map.fetch!(mapping, digit |> map(&Map.fetch!(freqs, &1)) |> sort()) end)
  |> Integer.undigits()
end)
|> sum()
|> IO.inspect(label: "part 2")
