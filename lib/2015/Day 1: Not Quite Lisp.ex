defmodule Aoc.NotQuiteLisp do
  def solve(1, text) do
    %{"(" => open, ")" => close} = text |> String.graphemes() |> Enum.frequencies()
    open - close
  end

  def solve(2, text) do
    floors =
      text
      |> String.graphemes()
      |> Stream.transform(_floor = 0, fn
        ")", 0 -> {:halt, -1}
        ")", f -> {[f], f - 1}
        "(", f -> {[f], f + 1}
      end)

    Enum.count(floors) + 1
  end
end
