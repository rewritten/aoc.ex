defmodule Aoc.SonarSweep do
  def parse(text) do
    text
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def part_1(data) do
    data
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [x, y] -> y > x end)
  end

  def part_2(data) do
    data
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [x, y] -> y > x end)
  end
end
