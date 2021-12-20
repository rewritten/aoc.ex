#! /usr/bin/env elixir

scanner_data =
  "input/2021/19.txt"
  |> File.read!()
  |> String.split("\n\n", trim: true)
  |> Enum.map(fn s ->
    ~r"-?\d+"
    |> Regex.scan(s)
    |> Enum.map(fn [n] -> String.to_integer(n) end)
    |> Enum.drop(1)
    |> Enum.chunk_every(3)
  end)
  |> Enum.with_index()

# Precompute inter-point vectors for each area. As transforms are linear, they
# will apply equally to points and vectors.
in_area_vectors =
  for {points, idx} <- scanner_data, into: %{} do
    {idx,
     for [x, y, z] = p <- points, [a, b, c] = q <- points, p != q, into: MapSet.new() do
       [x - a, y - b, z - c]
     end}
  end

# Precompute which areas are neighbors (12 common points -> 66 common inter-point distances)
distances = &for [x, y, z] <- &1, into: MapSet.new(), do: x * x + y * y + z * z

neighbours =
  for i <- 0..(length(scanner_data) - 2),
      j <- (i + 1)..(length(scanner_data) - 1),
      s = in_area_vectors |> Map.get(i) |> then(distances),
      t = in_area_vectors |> Map.get(j) |> then(distances),
      MapSet.intersection(s, t) |> MapSet.size() >= 66 do
    {i, j}
  end

# Prepare the list of 24 chiral rotations
rotations =
  for r <- [& &1, fn [x, y, z] -> [x, -y, -z] end],
      s <- [& &1, fn [x, y, z] -> [-x, y, -z] end],
      t <- [& &1, fn [x, y, z] -> [-z, -y, -x] end],
      u <- [& &1, fn [x, y, z] -> [y, z, x] end, fn [x, y, z] -> [z, x, y] end] do
    fn [x, y, z] -> r.(s.(t.(u.([x, y, z])))) end
  end

# Stitch areas together, keeping track of the applied transformations.

# Initial data
beacons = scanner_data |> hd() |> elem(0) |> MapSet.new()
applied_rotations = %{0 => & &1}
applied_translations = %{0 => [0, 0, 0]}
remaining_areas = tl(scanner_data)

{beacons, _, origins, _} =
  {beacons, applied_rotations, applied_translations, remaining_areas}
  |> Stream.iterate(fn {beac, rots, transls, rest} ->
    # Find a pair of areas that can be stitched, one among the already stitched
    # and the other among the remaining areas.
    # Retrieve also the rotation that was used to stitch the already stitched
    # area.
    [{i, j, rot_for_i, area} | _] =
      for {i, rot_for_i} <- rots,
          {area, j} <- rest,
          {i, j} in neighbours or {j, i} in neighbours do
        {i, j, rot_for_i, area}
      end

    # Use the vectors to find the rotation that makes the two areas fit
    target_vectors = in_area_vectors |> Map.get(i) |> MapSet.new()
    tentative_vectors = in_area_vectors |> Map.get(j)

    # This rotation will align area j to the original area i
    rot_from_j_to_i =
      Enum.find_value(rotations, fn rot ->
        rotated = for p <- tentative_vectors, into: MapSet.new(), do: rot.(p)
        intersection = MapSet.intersection(rotated, target_vectors)
        if MapSet.size(intersection) >= 132, do: rot
      end)

    # Rotate area j so it is aligned with the stitched zone, applying the
    # rotation from j to i, and then the stored rotation to stitch area i.
    actual_rot = &rot_for_i.(rot_from_j_to_i.(&1))
    rotated_area_j = for p <- area, do: actual_rot.(p)

    # Try to match the rotated area with some point of the existing bacons.
    # Stop as soon as there are 12 matching points.
    {moved_beacons, new_origin} =
      beac
      |> Stream.flat_map(fn [a, b, c] ->
        Stream.flat_map(rotated_area_j, fn [x, y, z] ->
          translated = for [p, q, r] <- rotated_area_j, do: [p - x + a, q - y + b, r - z + c]

          if Enum.count(translated, fn v -> v in beac end) >= 12,
            do: [{translated, [-x + a, -y + b, -z + c]}],
            else: []
        end)
      end)
      |> Enum.at(0)

    # Add the moved beacons to the stitched area
    beac = moved_beacons |> MapSet.new() |> MapSet.union(beac)
    # Save the rotation used to move area j
    rots = Map.put(rots, j, actual_rot)
    # Save the translation used to move area j
    transls = Map.put(transls, j, new_origin)
    # Remove the area just stitched from the remaining areas
    rest = List.keydelete(rest, j, 1)
    {beac, rots, transls, rest}
  end)
  |> Enum.find(&match?({_, _, _, []}, &1))

beacons
|> MapSet.size()
|> IO.inspect(label: "part 1")

for {_, [x, y, z]} <- origins, {_, [a, b, c]} <- origins do
  abs(x - a) + abs(y - b) + abs(z - c)
end
|> Enum.max()
|> IO.inspect(label: "part 2")
