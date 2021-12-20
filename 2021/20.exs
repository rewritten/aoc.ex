#! /usr/bin/env elixir

[algorithm_data, image_data] =
  "input/2021/20.txt" |> File.read!() |> String.split("\n\n", trim: true)

algorithm =
  for {c, i} <- algorithm_data |> String.to_charlist() |> Enum.with_index(),
      c in '.#',
      into: %{},
      do: if(c == ?., do: {i, 0}, else: {i, 1})

image =
  for {line, i} <- image_data |> String.split() |> Enum.with_index(),
      {c, j} <- line |> String.to_charlist() |> Enum.with_index(),
      into: %{},
      do: {{i, j}, if(c == ?., do: 0, else: 1)}

process = fn {image, bg, minim, maxim} ->
  bg_index = if bg == 0, do: 0, else: 511
  new_bg = Map.get(algorithm, bg_index)

  new_img =
    for x <- (minim - 1)..(maxim + 1),
        y <- (minim - 1)..(maxim + 1),
        into: %{} do
      idx =
        for i <- -1..1, j <- -1..1 do
          Map.get(image, {x + i, y + j}, bg)
        end
        |> Integer.undigits(2)

      {{x, y}, Map.get(algorithm, idx)}
    end

  {new_img, new_bg, minim - 1, maxim + 1}
end

for {reps, label} <- [{2, "part 1"}, {50, "part 2"}] do
  Stream.iterate({image, 0, 0, 99}, process)
  |> Enum.at(reps)
  |> elem(0)
  |> Map.values()
  |> Enum.count(&(&1 == 1))
  |> IO.inspect(label: label)
end
