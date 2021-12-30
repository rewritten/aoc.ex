defmodule Aoc.TrickShot do
  def solve(1, data) do
    max_vertical_velocity =
      data |> Input.i() |> valid_velocities() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    div(max_vertical_velocity * (max_vertical_velocity + 1), 2)
  end

  def solve(2, data) do
    data |> Input.i() |> valid_velocities() |> length()
  end

  defp valid_velocities([x1, x2, y1, y2]) do
    for dx <- 0..x2,
        dy <- y1..-y1,
        {x, y} <- trajectory(0, 0, dx, dy, x2, y1),
        x in x1..x2,
        y in y1..y2,
        uniq: true,
        do: {dx, dy}
  end

  defp trajectory(x, _, _, _, maxx, _) when x > maxx, do: []
  defp trajectory(_, y, _, _, _, miny) when y < miny, do: []

  defp trajectory(x, y, 0, dy, maxx, miny) do
    [{x, y} | trajectory(x, y + dy, 0, dy - 1, maxx, miny)]
  end

  defp trajectory(x, y, dx, dy, maxx, miny) do
    [{x, y} | trajectory(x + dx, y + dy, dx - 1, dy - 1, maxx, miny)]
  end
end
