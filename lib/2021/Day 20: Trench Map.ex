defmodule Aoc.TrenchMap do
  def solve(1, text), do: do_solve(text, 2)

  def solve(2, text), do: do_solve(text, 50)

  defp do_solve(input, iterations) do
    [algorithm_data, image_data] = Input.p(input)

    algorithm =
      Input.matrix(algorithm_data, &if(&1 == ?., do: 0, else: 1))
      |> hd()
      |> Enum.with_index()
      |> Map.new(fn {x, i} -> {i, x} end)

    image = Input.sparse_matrix(image_data, &if(&1 == ?., do: 0, else: 1))

    Stream.iterate({image, 0, 0, 99}, &process(&1, algorithm))
    |> Enum.at(iterations)
    |> elem(0)
    |> Map.values()
    |> Enum.count(&(&1 == 1))
  end

  defp process({image, 0, minim, maxim}, %{0 => new_bg} = algo) do
    {extend(image, 0, minim, maxim, algo), new_bg, minim - 1, maxim + 1}
  end

  defp process({image, 1, minim, maxim}, %{511 => new_bg} = algo) do
    {extend(image, 1, minim, maxim, algo), new_bg, minim - 1, maxim + 1}
  end

  defp process({image, bg, minim, maxim}, algorithm) do
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

  defp extend(image, bg, minim, maxim, algo) do
    for x <- (minim - 1)..(maxim + 1),
        y <- (minim - 1)..(maxim + 1),
        into: %{} do
      idx =
        for i <- -1..1, j <- -1..1 do
          Map.get(image, {x + i, y + j}, bg)
        end
        |> Integer.undigits(2)

      {{x, y}, Map.get(algo, idx)}
    end
  end
end
