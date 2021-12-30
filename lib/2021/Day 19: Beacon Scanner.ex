defmodule Aoc.BeaconScanner do
  def solve(1, text) do
    text |> parse() |> reduce() |> elem(0) |> MapSet.size()
  end

  def solve(2, text) do
    origins = text |> parse() |> reduce() |> elem(2)

    for [x, y, z] <- origins, [a, b, c] <- origins do
      abs(x - a) + abs(y - b) + abs(z - c)
    end
    |> Enum.max()
  end

  defp parse(text) do
    text
    |> Input.p()
    |> Enum.map(fn s ->
      beacons = s |> Input.l(map: :i) |> Enum.drop(1) |> MapSet.new()

      vecs =
        for [x, y, z] = p <- beacons, [a, b, c] = q <- beacons, p != q, into: MapSet.new() do
          [x - a, y - b, z - c]
        end

      ds = MapSet.new(vecs, fn [x, y, z] -> abs(x) + abs(y) + abs(z) end)

      {beacons, vecs, ds}
    end)
  end

  # Attempt to stitch one sensor data with the rest, recursively. If the front
  # batch cannot be stitched, it is moved to the back.
  def reduce([{b, v, d} | rest]), do: reduce(rest, {b, [{b, v, d}], [[0, 0, 0]]})
  def reduce([], state), do: state

  def reduce([area | rest], {beacons, adjusted, origins}) do
    case Enum.find_value(adjusted, &try_match(area, &1)) do
      {{b0, v0, d0}, {b1, _, _}, rot} ->
        r_b0 = MapSet.new(b0, rot)
        r_v0 = MapSet.new(v0, rot)

        {moved, origin} =
          Enum.find_value(b1, fn [a, b, c] ->
            Enum.find_value(r_b0, fn [x, y, z] ->
              moved = MapSet.new(r_b0, fn [p, q, r] -> [p - x + a, q - y + b, r - z + c] end)

              if moved |> MapSet.intersection(b1) |> MapSet.size() >= 12,
                do: {moved, [a - x, b - y, c - z]}
            end)
          end)

        reduce(
          rest,
          {MapSet.union(beacons, moved), [{moved, r_v0, d0} | adjusted], [origin | origins]}
        )

      _ ->
        reduce(rest ++ [area], {beacons, adjusted, origins})
    end
  end

  # Given two sets of beacons, if they are overlapping return
  # them plus the rotation that brings the first parallel to the second.
  def try_match({b0, v0, d0}, {b1, v1, d1}) do
    if d1 |> MapSet.intersection(d0) |> MapSet.size() >= 66 do
      r =
        Enum.find(rotations(), fn rot ->
          v0 |> MapSet.new(rot) |> MapSet.intersection(v1) |> MapSet.size() >= 132
        end)

      if r, do: {{b0, v0, d0}, {b1, v1, d1}, r}
    end
  end

  # This, but expanded:
  # for r <- [& &1, fn [x, y, z] -> [x, -y, -z] end],
  #     s <- [& &1, fn [x, y, z] -> [-x, y, -z] end],
  #     t <- [& &1, fn [x, y, z] -> [-z, -y, -x] end],
  #     u <- [& &1, fn [x, y, z] -> [y, z, x] end, fn [x, y, z] -> [z, x, y] end] do
  #   fn [x, y, z] -> r.(s.(t.(u.([x, y, z])))) end
  # end
  defp rotations() do
    [
      fn [x, y, z] -> [x, y, z] end,
      fn [x, y, z] -> [y, z, x] end,
      fn [x, y, z] -> [z, x, y] end,
      fn [x, y, z] -> [-z, -y, -x] end,
      fn [x, y, z] -> [-x, -z, -y] end,
      fn [x, y, z] -> [-y, -x, -z] end,
      fn [x, y, z] -> [-x, y, -z] end,
      fn [x, y, z] -> [-y, z, -x] end,
      fn [x, y, z] -> [-z, x, -y] end,
      fn [x, y, z] -> [z, -y, x] end,
      fn [x, y, z] -> [x, -z, y] end,
      fn [x, y, z] -> [y, -x, z] end,
      fn [x, y, z] -> [x, -y, -z] end,
      fn [x, y, z] -> [y, -z, -x] end,
      fn [x, y, z] -> [z, -x, -y] end,
      fn [x, y, z] -> [-z, y, x] end,
      fn [x, y, z] -> [-x, z, y] end,
      fn [x, y, z] -> [-y, x, z] end,
      fn [x, y, z] -> [-x, -y, z] end,
      fn [x, y, z] -> [-y, -z, x] end,
      fn [x, y, z] -> [-z, -x, y] end,
      fn [x, y, z] -> [z, y, -x] end,
      fn [x, y, z] -> [x, z, -y] end,
      fn [x, y, z] -> [y, x, -z] end
    ]
  end
end
