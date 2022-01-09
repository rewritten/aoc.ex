defmodule Aoc.CorporatePolicy do
  def solve(1, text), do: do_solve(text, 1)
  def solve(2, text), do: do_solve(text, 2)

  defp do_solve(text, skip) do
    text
    |> Input.matrix()
    |> hd()
    |> Enum.reverse()
    |> Stream.iterate(&next/1)
    |> Stream.filter(&has_incr/1)
    |> Stream.filter(&has_two_pairs/1)
    |> Enum.at(skip - 1)
    |> Enum.reverse()
    |> List.to_string()
  end

  defp next([?z | rest]), do: [?a | next(rest)]
  defp next([char | rest]) when char in 'hkn', do: [char + 2 | rest]
  defp next([char | rest]), do: [char + 1 | rest]

  defp has_incr([_, _]), do: false
  defp has_incr([z, y, x | _]) when z == y + 1 and y == x + 1, do: true
  defp has_incr([_ | t]), do: has_incr(t)

  defp has_two_pairs([_, _, _]), do: false
  defp has_two_pairs([a, a | t]), do: has_one_pair(t)
  defp has_two_pairs([_ | t]), do: has_two_pairs(t)

  defp has_one_pair([]), do: false
  defp has_one_pair([_]), do: false
  defp has_one_pair([a, a | _]), do: true
  defp has_one_pair([_ | t]), do: has_one_pair(t)
end
