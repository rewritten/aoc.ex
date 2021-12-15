#! /usr/bin/env elixir

[initial, replacement_data] =
  "input/2021/14.txt" |> File.read!() |> String.split("\n\n", trim: true)

replacements =
  ~r"[A-Z]+"
  |> Regex.scan(replacement_data)
  |> Enum.map(&hd/1)
  |> Enum.chunk_every(2)
  |> Map.new(&List.to_tuple/1)

merge_counters = &Map.merge(&1, &2, fn _, v1, v2 -> v1 + v2 end)

# iteratively counts the characters obtained expanding N times a pair
# excluding the final character, and stores them in a map {[pair], iteration} => %{counts}
freqs =
  for level <- 1..40, {<<l, r>>, <<inter>>} <- replacements, reduce: %{} do
    m ->
      left = Map.get(m, {[l, inter], level - 1}, %{l => 1})
      right = Map.get(m, {[inter, r], level - 1}, %{inter => 1})
      Map.put(m, {[l, r], level}, merge_counters.(left, right))
  end

for {level, label} <- [{10, "part 1"}, {40, "part 2"}] do
  initial
  |> String.to_charlist()
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.map(&Map.get(freqs, {&1, level}))
  |> Enum.reduce(%{(initial |> String.to_charlist() |> List.last()) => 1}, merge_counters)
  |> Map.values()
  |> Enum.min_max()
  |> then(fn {min, max} -> max - min end)
  |> IO.inspect(label: label)
end
