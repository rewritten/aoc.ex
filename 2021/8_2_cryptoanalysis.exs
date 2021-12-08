#! /usr/bin/env elixir

# Use frequency analysis to find the transposition key

"input/2021/8.txt"
|> File.read!()
|> String.split(~r"[^a-g]+", trim: true)
|> Enum.map(&String.to_charlist/1)
|> Enum.chunk_every(14)
|> Enum.map(fn line ->
  {digits, input} = Enum.split(line, 10)
  freqs = digits |> List.flatten() |> Enum.frequencies()

  input
  |> Enum.map(fn d ->
    case d |> Enum.map(&Map.get(freqs, &1)) |> Enum.sort() do
      [4, 6, 7, 8, 8, 9] -> 0
      [8, 9] -> 1
      [4, 7, 7, 8, 8] -> 2
      [7, 7, 8, 8, 9] -> 3
      [6, 7, 8, 9] -> 4
      [6, 7, 7, 8, 9] -> 5
      [4, 6, 7, 7, 8, 9] -> 6
      [8, 8, 9] -> 7
      [4, 6, 7, 7, 8, 8, 9] -> 8
      [6, 7, 7, 8, 8, 9] -> 9
    end
  end)
  |> Integer.undigits()
end)
|> Enum.sum()
|> IO.inspect(label: "part 2")
