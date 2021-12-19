#! /usr/bin/env elixir

defmodule Probes do
  def trajectory(x, _, _, _, maxx, _) when x > maxx, do: []
  def trajectory(_, y, _, _, _, miny) when y < miny, do: []

  def trajectory(x, y, 0, dy, maxx, miny) do
    [{x, y} | trajectory(x, y + dy, 0, dy - 1, maxx, miny)]
  end

  def trajectory(x, y, dx, dy, maxx, miny) do
    [{x, y} | trajectory(x + dx, y + dy, dx - 1, dy - 1, maxx, miny)]
  end
end

[x1, x2, y1, y2] =
  "input/2021/17.txt"
  |> File.read!()
  |> then(&Regex.scan(~r/-?\d+/, &1))
  |> List.flatten()
  |> Enum.map(&String.to_integer/1)

velocities =
  for dx <- 0..x2,
      dy <- y1..-y1,
      {x, y} <- Probes.trajectory(0, 0, dx, dy, x2, y1),
      x in x1..x2,
      y in y1..y2,
      uniq: true,
      do: {dx, dy}

velocities
|> Enum.map(&elem(&1, 1))
|> Enum.max()
|> then(&div(&1 * (&1 + 1), 2))
|> IO.inspect(label: "part 1")

velocities
|> length()
|> IO.inspect(label: "part 2")
