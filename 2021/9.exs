#! /usr/bin/env elixir

# Create a Map from coordinates to depths. Skip the 9s
input =
  for {line, i} <- "input/2021/9.txt" |> File.read!() |> String.split() |> Enum.with_index(),
      {c, j} <- line |> String.to_charlist() |> Enum.with_index(),
      c != ?9,
      into: %{},
      do: {{i, j}, c}

# Find the bottoms
for {{i, j}, c} <- input,
    Map.get(input, {i, j + 1}, ?9) > c,
    Map.get(input, {i, j - 1}, ?9) > c,
    Map.get(input, {i + 1, j}, ?9) > c,
    Map.get(input, {i - 1, j}, ?9) > c do
  c - ?0 + 1
end
|> Enum.sum()
|> IO.inspect(label: "part 1")

# BFS to find the connected components
{input, %{}, []}
|> Stream.unfold(fn {space, component, keys} ->
  {neigh, rest} = Map.split(space, keys)

  if map_size(neigh) == 0 do
    with {k, _} <- Enum.at(space, 0), do: {component, {space, %{}, [k]}}
  else
    {nil,
     {rest, Map.merge(component, neigh),
      Enum.flat_map(neigh, fn {{i, j}, _} -> [{i, j + 1}, {i, j - 1}, {i + 1, j}, {i - 1, j}] end)}}
  end
end)
|> Enum.reject(&is_nil/1)
|> Enum.map(&map_size/1)
|> Enum.sort(&Kernel.>=/2)
|> Enum.take(3)
|> Enum.reduce(&Kernel.*/2)
|> IO.inspect(label: "part 2")
