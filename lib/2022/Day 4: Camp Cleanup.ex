defmodule Aoc.CampCleanup do
  def solve(1, text) do
    text
    |> String.split(~r"\W+", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4)
    |> Enum.count(fn [a, b, c, d] -> (a >= c and b <= d) or (a <= c and b >= d) end)
  end

  def solve(2, text) do
    text
    |> String.split(~r"\W+", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4)
    |> Enum.count(fn [a, b, c, d] -> a <= d and b >= c end)
  end
end
