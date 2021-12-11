#! /usr/bin/env elixir

Mix.install([:libgraph])

add_edge_if_ok = fn from, to ->
  &if Graph.has_vertex?(&1, to), do: Graph.add_edge(&1, from, to), else: &1
end

lines = "input/2021/9.txt" |> File.read!() |> String.split()

graph =
  for {line, i} <- Enum.with_index(lines),
      {c, j} <- line |> String.to_charlist() |> Enum.with_index(),
      c != ?9,
      reduce: Graph.new(type: :undirected) do
    g ->
      g
      |> Graph.add_vertex({i, j})
      |> then(add_edge_if_ok.({i, j}, {i, j - 1}))
      |> then(add_edge_if_ok.({i, j}, {i - 1, j}))
  end

graph
|> Graph.components()
|> Enum.map(&length/1)
|> Enum.sort(&Kernel.>=/2)
|> Enum.take(3)
|> Enum.reduce(&Kernel.*/2)
|> IO.inspect(label: "part 2")
