defmodule Aoc.SonarSweep do
  def solve(1, input) do
    input
    |> Input.i()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [x, y] -> y > x end)
  end

  def solve(2, input) do
    input
    |> Input.i()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [x, y] -> y > x end)
  end
end
