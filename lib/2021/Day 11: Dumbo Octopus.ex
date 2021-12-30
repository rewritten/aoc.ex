defmodule Aoc.DumboOctopus do
  def solve(1, input) do
    input
    |> Input.sparse_matrix(&(&1 - ?0))
    |> step()
    |> Stream.iterate(&step/1)
    |> Stream.map(&Enum.count(&1, fn {_, v} -> v == 0 end))
    |> Stream.take(100)
    |> Enum.sum()
  end

  def solve(2, input) do
    input
    |> Input.sparse_matrix(&(&1 - ?0))
    |> Stream.iterate(&step/1)
    |> Enum.find_index(&Enum.all?(&1, fn {_, v} -> v == 0 end))
  end

  defp step(this) do
    this
    |> Map.map(fn {_, val} -> val + 1 end)
    |> Stream.iterate(&flash/1)
    |> Stream.chunk_every(2, 1)
    |> Enum.find(&match?([a, a], &1))
    |> hd()
  end

  defp flash(this) do
    case Enum.find(this, fn {_, v} -> v > 9 end) do
      nil ->
        this

      {{x, y}, _} ->
        coords = for i <- -1..1, j <- -1..1, do: {x + i, y + j}

        increased =
          this
          |> Map.take(coords)
          |> Map.reject(&match?({_, 0}, &1))
          |> Map.map(fn {_, v} -> v + 1 end)

        this
        |> Map.merge(increased)
        |> Map.put({x, y}, 0)
    end
  end
end
