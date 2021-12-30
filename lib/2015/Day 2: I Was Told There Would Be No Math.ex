defmodule Aoc.IWasToldThereWouldBeNoMath do
  def solve(1, text) do
    text
    |> Input.l(
      map: :i,
      map: &Enum.sort/1,
      map: fn [x, y, z] -> 3 * x * y + 2 * x * z + 2 * y * z end
    )
    |> Enum.sum()
  end

  def solve(2, text) do
    text
    |> Input.l(map: :i, map: &Enum.sort/1, map: fn [x, y, z] -> 2 * (x + y) + x * y * z end)
    |> Enum.sum()
  end
end
