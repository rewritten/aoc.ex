defmodule Aoc.RucksackReorganization do
  def solve(1, text) do
    for sack <- String.split(text, "\n", trim: true) do
      sack
      |> String.to_charlist()
      |> Enum.chunk_every(div(String.length(sack), 2))
      |> Enum.map(&MapSet.new/1)
      |> Enum.reduce(&MapSet.intersection/2)
      |> Enum.at(0)
      |> case do
        c when c in ?A..?Z -> c - ?A + 27
        c when c in ?a..?z -> c - ?a + 1
      end
    end
    |> Enum.sum()
  end

  def solve(2, text) do
    for sack <- String.split(text, "\n", trim: true) do
      String.to_charlist(sack)
    end
    |> Enum.chunk_every(3)
    |> Enum.map(fn sacks ->
      sacks
      |> Enum.map(&MapSet.new/1)
      |> Enum.reduce(&MapSet.intersection/2)
      |> Enum.at(0)
      |> case do
        c when c in ?A..?Z -> c - ?A + 27
        c when c in ?a..?z -> c - ?a + 1
      end
    end)
    |> Enum.sum()
  end
end
