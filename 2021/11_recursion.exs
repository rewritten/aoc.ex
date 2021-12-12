#! /usr/bin/env elixir
defmodule M do
  def step(map) do
    map
    |> Map.map(fn {_, v} -> v + 1 end)
    |> turn(MapSet.new())
    |> Map.map(fn {_, v} -> if v > ?9, do: ?0, else: v end)
  end

  def turn(map, flashed) do
    case Enum.find(map, fn {k, v} -> v > ?9 && k not in flashed end) do
      {{x, y}, _} ->
        map =
          for i <- (x - 1)..(x + 1),
              j <- (y - 1)..(y + 1),
              Map.has_key?(map, {i, j}),
              reduce: map do
            m -> Map.update!(m, {i, j}, &(&1 + 1))
          end

        turn(map, MapSet.put(flashed, {x, y}))

      nil ->
        map
    end
  end
end

loop =
  for {line, i} <- "input/2021/11.txt" |> File.read!() |> String.split() |> Enum.with_index(),
      {c, j} <- line |> String.to_charlist() |> Enum.with_index(),
      into: %{} do
    {{i, j}, c}
  end
  |> Stream.iterate(&M.step/1)

loop
|> Stream.take(101)
|> Stream.map(&Enum.count(&1, fn {_, v} -> v == ?0 end))
|> Enum.sum()
|> IO.inspect(label: "part 1")

loop
|> Enum.find_index(&Enum.all?(&1, fn {_, v} -> v == ?0 end))
|> IO.inspect(label: "part 2")
