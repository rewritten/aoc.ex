#! /usr/bin/env elixir

Mix.install([:libgraph])

add_edge = fn g, from, to ->
  if Graph.has_vertex?(g, to), do: Graph.add_edge(g, from, to), else: g
end

graph =
  for {line, i} <- "input/2021/9.txt" |> File.read!() |> String.split() |> Enum.with_index(),
      {c, j} <- line |> String.to_charlist() |> Enum.with_index(),
      c != ?9,
      reduce: Graph.new(type: :undirected) do
    g ->
      g
      |> Graph.add_vertex({i, j})
      |> then(&add_edge.(&1, {i, j}, {i, j - 1}))
      |> then(&add_edge.(&1, {i, j}, {i - 1, j}))
  end

graph
|> Graph.components()
|> Enum.map(&length/1)
|> Enum.sort(&Kernel.>=/2)
|> Enum.take(3)
|> Enum.reduce(&Kernel.*/2)
|> IO.inspect(label: "part 2")
