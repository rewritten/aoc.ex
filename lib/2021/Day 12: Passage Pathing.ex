defmodule Aoc.PassagePathing do
  def solve(1, data) do
    data = parse(data)

    :queue.from_list([["start"]])
    |> Stream.unfold(fn queue -> queue |> :queue.out() |> step(data) end)
    |> Enum.count(& &1)
  end

  def solve(2, data) do
    data = parse(data)

    :queue.from_list([{["start"], true}])
    |> Stream.unfold(fn queue -> queue |> :queue.out() |> step(data) end)
    |> Enum.count(& &1)
  end

  defp parse(text) do
    text
    |> String.split(~r"\W+", trim: true)
    |> Enum.chunk_every(2)
    |> Enum.flat_map(fn [a, b] -> [%{a => [b]}, %{b => [a]}] end)
    |> Enum.reduce(&Map.merge(&1, &2, fn _, v, w -> v ++ w end))
    |> Map.map(fn {_, v} -> v -- ["start"] end)
  end

  defp step({:empty, _}, _), do: nil
  defp step({{:value, ["end" | _]}, queue}, _), do: {true, queue}
  defp step({{:value, {["end" | _], _}}, queue}, _), do: {true, queue}

  defp step({{:value, [h | _] = path}, queue}, data) do
    items = for n <- Map.get(data, h), n not in path or n == String.upcase(n), do: [n | path]
    {false, Enum.reduce(items, queue, &:queue.in/2)}
  end

  defp step({{:value, {[h | _] = path, true}}, queue}, data) do
    items = for n <- Map.get(data, h), do: {[n | path], String.downcase(n) not in path}
    {false, Enum.reduce(items, queue, &:queue.in/2)}
  end

  defp step({{:value, {[h | _] = path, false}}, queue}, data) do
    items =
      for n <- Map.get(data, h), n not in path or n == String.upcase(n), do: {[n | path], false}

    {false, Enum.reduce(items, queue, &:queue.in/2)}
  end
end
