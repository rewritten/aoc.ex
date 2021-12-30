defmodule Aoc.TransparentOrigami do
  def solve(1, input) do
    {points, [first | _]} = parse(input)
    first |> fold(points) |> Enum.count()
  end

  def solve(2, input) do
    {points, folds} = parse(input)
    display = " " |> List.duplicate(100) |> List.duplicate(100)

    folds
    |> Enum.reduce(points, &fold/2)
    |> Enum.reduce(display, fn {x, y}, acc ->
      List.update_at(acc, y, &List.replace_at(&1, x, "#"))
    end)
    |> Enum.map(&(&1 |> Enum.join() |> String.trim_trailing()))
    |> Enum.join("\n")
    |> String.trim_trailing()
    |> Kernel.<>("\n")
  end

  defp parse(text) do
    [point_data, fold_data] = Input.p(text)

    points = Input.l(point_data, map: :i, map: &List.to_tuple/1)

    folds =
      Input.l(fold_data,
        map: fn
          "fold along x=" <> num -> {0, String.to_integer(num)}
          "fold along y=" <> num -> {1, String.to_integer(num)}
        end
      )

    {points, folds}
  end

  defp fold({0, val}, pts), do: for({x, y} <- pts, uniq: true, do: {min(2 * val - x, x), y})
  defp fold({1, val}, pts), do: for({x, y} <- pts, uniq: true, do: {x, min(2 * val - y, y)})
end
