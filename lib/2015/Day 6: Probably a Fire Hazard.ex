defmodule Aoc.ProbablyAFireHazard do
  def solve(1, text) do
    text
    |> Input.l(
      map: fn line ->
        [x0, y0, x1, y1] = Input.i(line)
        {line, x0..x1, y0..y1}
      end
    )
    |> Enum.map(fn
      {"turn on" <> _, rx, ry} ->
        for x <- rx, y <- ry, do: Process.put({x, y}, 1)

      {"turn off" <> _, rx, ry} ->
        for x <- rx, y <- ry, do: Process.delete({x, y})

      {"toggle" <> _, rx, ry} ->
        for x <- rx, y <- ry do
          if !Process.delete({x, y}), do: Process.put({x, y}, 1)
        end
    end)

    Process.get_keys(1) |> length()
  end

  def solve(2, text) do
    text
    |> Input.l(
      map: fn line ->
        [x0, y0, x1, y1] = Input.i(line)
        {line, x0..x1, y0..y1}
      end
    )
    |> Enum.map(fn
      {"turn on" <> _, rx, ry} ->
        for x <- rx, y <- ry do
          case Process.get({x, y}) do
            nil -> Process.put({x, y}, 1)
            n -> Process.put({x, y}, n + 1)
          end
        end

      {"turn off" <> _, rx, ry} ->
        for x <- rx, y <- ry do
          case Process.get({x, y}) do
            nil -> nil
            1 -> Process.delete({x, y})
            n -> Process.put({x, y}, n - 1)
          end
        end

      {"toggle" <> _, rx, ry} ->
        for x <- rx, y <- ry do
          case Process.get({x, y}) do
            nil -> Process.put({x, y}, 2)
            n -> Process.put({x, y}, n + 2)
          end
        end
    end)

    1..300
    |> Enum.map(fn value ->
      count = value |> Process.get_keys() |> length()
      count * value
    end)
    |> Enum.sum()
  end
end
