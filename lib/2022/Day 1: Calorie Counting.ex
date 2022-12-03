defmodule Aoc.CalorieCounting do
  def solve(1, text),
    do:
      text
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn p ->
        Enum.sum(p |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1))
      end)
      |> Enum.max()

  def solve(2, text),
    do:
      text
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn p ->
        Enum.sum(p |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1))
      end)
      |> Enum.sort(:desc)
      |> Enum.take(3)
      |> Enum.sum()
end
