#! /usr/bin/env elixir

[point_data, fold_data] = "input/2021/13.txt" |> File.read!() |> String.split("\n\n", trim: true)

points =
  ~r"\d+"
  |> Regex.scan(point_data)
  |> List.flatten()
  |> Enum.map(&String.to_integer/1)
  |> Enum.chunk_every(2)

folds =
  ~r"(x|y)=(\d+)"
  |> Regex.scan(fold_data, capture: :all_but_first)
  |> Enum.map(fn [dir, val] -> [if(dir == "x", do: 0, else: 1), String.to_integer(val)] end)

{[first | _], final} =
  folds
  |> Enum.map_reduce(points, fn [dir, val], pts ->
    folded = for z <- pts, uniq: true, do: List.update_at(z, dir, &min(2 * val - &1, &1))
    {folded, folded}
  end)

first
|> Enum.count()
|> IO.inspect(label: "part 1")

IO.puts("part 2:")
[xmax, ymax] = final |> Enum.zip_with(& &1) |> Enum.map(&Enum.max/1)
display = List.duplicate(List.duplicate(32, ymax + 1), xmax + 1)

final
|> Enum.map(fn z -> Enum.map(z, &Access.at/1) end)
|> Enum.reduce(display, &put_in(&2, &1, ?#))
|> Enum.zip_with(& &1)
|> Enum.map(&IO.puts/1)
