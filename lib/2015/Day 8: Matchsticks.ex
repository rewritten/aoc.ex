defmodule Aoc.Matchsticks do
  def solve(1, text) do
    text
    |> Input.l(
      map: fn line -> String.length(line) - String.length(elem(Code.eval_string(line), 0)) end
    )
    |> Enum.sum()
  end

  def solve(2, text) do
    text
    |> Input.l(map: fn line -> String.length(inspect(line)) - String.length(line) end)
    |> Enum.sum()
  end
end
