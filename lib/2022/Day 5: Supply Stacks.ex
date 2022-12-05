defmodule Aoc.SupplyStacks do
  import Enum

  def solve(1, text), do: do_solve(text, &crate_mover_9000/2)
  def solve(2, text), do: do_solve(text, &crate_mover_9001/2)

  defp do_solve(text, crane) do
    [stack_info, rules] = String.split(text, "\n\n", trim: true)

    stacks =
      stack_info
      |> String.split("\n", trim: true)
      |> reverse()
      |> drop(1)
      |> map(&(&1 |> String.to_charlist() |> drop(1) |> take_every(4)))
      |> zip_with(& &1)
      |> map(fn stack -> stack |> reverse() |> filter(&(&1 != 32)) end)

    rules
    |> String.split(~r"\D+", trim: true)
    |> map(&String.to_integer/1)
    |> chunk_every(3)
    |> reduce(stacks, crane)
    |> map(&hd/1)
  end

  defp crate_mover_9000([count, from, to], stacks) do
    reduce(1..count, stacks, fn _, stacks -> crate_mover_9001([1, from, to], stacks) end)
  end

  defp crate_mover_9001([count, from, to], stacks) do
    stacks
    |> update_in([Access.at(from - 1)], &drop(&1, count))
    |> update_in([Access.at(to - 1)], &((stacks |> at(from - 1) |> take(count)) ++ &1))
  end
end
