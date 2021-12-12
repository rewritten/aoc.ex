#! /usr/bin/env elixir

data =
  "input/2021/12.txt"
  |> File.read!()
  |> String.split(~r"\W+", trim: true)
  |> Enum.chunk_every(2)
  |> Enum.flat_map(&[&1, Enum.reverse(&1)])
  |> Enum.reduce(%{}, fn [a, b], acc -> Map.update(acc, a, [b], &[b | &1]) end)
  |> Map.map(fn {_, v} -> v -- ["start"] end)

[["start"]]
|> Stream.iterate(fn paths ->
  {finished, running} = Enum.split_with(paths, &match?(["end" | _], &1))

  finished ++
    for [h | t] <- running,
        n <- Map.get(data, h),
        n not in t or n == String.upcase(n),
        do: [n, h | t]
end)
|> Stream.chunk_every(2, 1)
|> Enum.find(&match?([a, a], &1))
|> Enum.at(0)
|> length()
|> IO.inspect(label: "part 1")

[{["start"], true}]
|> Stream.iterate(fn paths ->
  {finished, running} = Enum.split_with(paths, &match?({["end" | _], _}, &1))

  finished ++
    for {[h | t], can_revisit} <- running,
        n <- Map.get(data, h),
        can_revisit or n not in t or n == String.upcase(n),
        do: {[n, h | t], can_revisit && String.downcase(n) not in t}
end)
|> Stream.chunk_every(2, 1)
|> Enum.find(&match?([a, a], &1))
|> Enum.at(0)
|> length()
|> IO.inspect(label: "part 2")
