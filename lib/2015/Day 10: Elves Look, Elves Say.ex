defmodule Aoc.ElvesLookElvesSay do
  def solve(1, text), do: do_solve(text, 40)
  def solve(2, text), do: do_solve(text, 50)

  defp do_solve(text, iterations) do
    text
    |> Input.matrix(&(&1 - ?0))
    |> hd()
    |> Stream.iterate(fn digits ->
      digits |> Enum.chunk_by(& &1) |> Enum.flat_map(fn l -> [length(l), hd(l)] end)
    end)
    |> Enum.at(iterations)
    |> length()
  end
end
