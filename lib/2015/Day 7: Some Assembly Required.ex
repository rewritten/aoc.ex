defmodule Aoc.SomeAssemblyRequired do
  use Bitwise, only_operators: true

  def solve(1, text) do
    data = Input.l(text, map: :i?)
    wires = %{}

    {data, wires}
    |> Stream.iterate(&do_solve/1)
    |> Enum.find(&match?({[], _}, &1))
    |> elem(1)
    |> Map.get("a")
  end

  def solve(2, text) do
    data = Input.l(text, map: :i?)
    wires = %{"b" => solve(1, text)}

    {data, wires}
    |> Stream.iterate(&do_solve_override/1)
    |> Enum.find(&match?({[], _}, &1))
    |> elem(1)
    |> Map.get("a")
  end

  defp do_solve({[[n, b] | rest], w}) when is_integer(n), do: {rest, Map.put(w, b, n)}

  defp do_solve({[[n, "AND", b, c] | rest], w}) when is_integer(n) and is_map_key(w, b),
    do: {rest, Map.put(w, c, n &&& Map.get(w, b))}

  defp do_solve({[[a, "AND", b, c] | rest], w}) when is_map_key(w, a) and is_map_key(w, b),
    do: {rest, Map.put(w, c, Map.get(w, a) &&& Map.get(w, b))}

  defp do_solve({[[a, "OR", b, c] | rest], w}) when is_map_key(w, a) and is_map_key(w, b),
    do: {rest, Map.put(w, c, Map.get(w, a) ||| Map.get(w, b))}

  defp do_solve({[[a, "LSHIFT", n, c] | rest], w}) when is_map_key(w, a) and is_integer(n),
    do: {rest, Map.put(w, c, Map.get(w, a) <<< n)}

  defp do_solve({[[a, "LSHIFT", b, c] | rest], w}) when is_map_key(w, a) and is_map_key(w, b),
    do: {rest, Map.put(w, c, Map.get(w, a) <<< Map.get(w, b))}

  defp do_solve({[[a, "RSHIFT", n, c] | rest], w}) when is_map_key(w, a) and is_integer(n),
    do: {rest, Map.put(w, c, Map.get(w, a) >>> n)}

  defp do_solve({[["NOT", a, c] | rest], w}) when is_map_key(w, a),
    do: {rest, Map.put(w, c, ~~~Map.get(w, a))}

  defp do_solve({[[a, c] | rest], w}) when is_map_key(w, a),
    do: {rest, Map.put(w, c, Map.get(w, a))}

  defp do_solve({line, wires}), do: {Enum.slide(line, 0, -1), wires}

  defp do_solve_override({[[n, "b"] | rest], w}) when is_integer(n), do: {rest, w}
  defp do_solve_override(other), do: do_solve(other)
end
