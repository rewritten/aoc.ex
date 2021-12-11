#! /usr/bin/env elixir

reduce = fn line ->
  {line, []}
  |> Stream.unfold(fn
    {"(" <> rest, acc} -> {nil, {rest, [")" | acc]}}
    {"[" <> rest, acc} -> {nil, {rest, ["]" | acc]}}
    {"{" <> rest, acc} -> {nil, {rest, ["}" | acc]}}
    {"<" <> rest, acc} -> {nil, {rest, [">" | acc]}}
    {<<c, rest::binary>>, [<<c>> | acc]} -> {nil, {rest, acc}}
    {")" <> _, _} -> {3, :halt}
    {"]" <> _, _} -> {57, :halt}
    {"}" <> _, _} -> {1197, :halt}
    {">" <> _, _} -> {25137, :halt}
    {"", missing} -> {missing, :halt}
    :halt -> nil
  end)
  |> Enum.find(& &1)
end

"input/2021/10.txt"
|> File.read!()
|> String.split()
|> Enum.map(reduce)
|> Enum.filter(&is_integer/1)
|> Enum.sum()
|> IO.inspect(label: "part 1")

"input/2021/10.txt"
|> File.read!()
|> String.split()
|> Enum.map(reduce)
|> Enum.filter(&is_list/1)
|> Enum.map(fn missing ->
  missing
  |> Enum.map(&(" )]}>" |> :binary.match(&1) |> elem(0)))
  |> Integer.undigits(5)
end)
|> Enum.sort()
|> then(&Enum.at(&1, &1 |> length() |> div(2)))
|> IO.inspect(label: "part 2")
