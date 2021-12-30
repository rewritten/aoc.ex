defmodule Aoc.ReactorReboot do
  def solve(1, text) do
    text
    |> parse()
    |> Enum.take_while(fn {cuboid, _} -> Enum.all?(cuboid, &(!Range.disjoint?(&1, -50..50))) end)
    |> perform()
  end

  def solve(2, text) do
    text |> parse() |> perform()
  end

  defp parse(text) do
    Input.l(text,
      map: fn line ->
        {~r"-?\d+..-?\d+"
         |> Regex.scan(line)
         |> List.flatten()
         |> Enum.map(&elem(Code.eval_string(&1), 0)), match?("on" <> _, line)}
      end
    )
  end

  defp perform(instructions) do
    for [a, b, c] <- do_perform(instructions, []), reduce: 0 do
      acc -> acc + Enum.count(a) * Enum.count(b) * Enum.count(c)
    end
  end

  defp do_perform([], state), do: state
  defp do_perform([{q, false} | rest], state), do: do_perform(rest, carve_all(state, q))
  defp do_perform([{q, true} | rest], state), do: do_perform(rest, [q | carve_all(state, q)])

  defp carve_all(cuboids, other) do
    Enum.flat_map(cuboids, fn qu -> if disjoint?(qu, other), do: [qu], else: carve(qu, other) end)
  end

  defp disjoint?([r1], [r2]), do: Range.disjoint?(r1, r2)
  defp disjoint?([r1 | rest1], [r2 | rest2]), do: disjoint?([r1], [r2]) || disjoint?(rest1, rest2)

  defp carve([], []), do: []

  defp carve([range | rest], [other | rest2]) do
    split(range, other)
    |> Enum.flat_map(fn chunk_x ->
      if Range.disjoint?(chunk_x, other) do
        [[chunk_x | rest]]
      else
        for proj <- carve(rest, rest2), do: [chunk_x | proj]
      end
    end)
  end

  defp split(a..b, x.._) when x > b, do: [a..b]
  defp split(a..b, x..y) when x > a and y >= b, do: [a..(x - 1), x..b]
  defp split(a..b, x..y) when x > a, do: [a..(x - 1), x..y, (y + 1)..b]
  defp split(a..b, _..y) when y >= a and y < b, do: [a..y, (y + 1)..b]
  defp split(a..b, _), do: [a..b]
end
