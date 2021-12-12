#! /usr/bin/env elixir

loop =
  for {line, i} <- "input/2021/11.txt" |> File.read!() |> String.split() |> Enum.with_index(),
      {c, j} <- line |> String.to_charlist() |> Enum.with_index(),
      into: %{} do
    {{i, j}, c}
  end
  |> Stream.iterate(fn map ->
    map
    |> Map.map(fn {_, val} -> val + 1 end)
    |> Stream.iterate(fn this ->
      with {{x, y}, _} <- Enum.find(this, fn {_, v} -> v > ?9 end) do
        for i <- (x - 1)..(x + 1),
            j <- (y - 1)..(y + 1),
            v = Map.get(this, {i, j}),
            v in ?1..?9,
            reduce: this do
          m -> Map.put(m, {i, j}, v + 1)
        end
        |> Map.put({x, y}, ?0)
      else
        nil -> this
      end
    end)
    |> Stream.chunk_every(2, 1)
    |> Enum.find_value(fn [a, b] -> if a == b, do: a end)
  end)

loop
|> Stream.map(&Enum.count(&1, fn {_, v} -> v == ?0 end))
|> Stream.take(101)
|> Enum.sum()
|> IO.inspect(label: "part 1")

loop
|> Enum.find_index(&Enum.all?(&1, fn {_, v} -> v == ?0 end))
|> IO.inspect(label: "part 2")
