#! /usr/bin/env elixir

defmodule Permutations do
  def next(list) do
    # return the "next" lexicographic permutation of list.
    # http://lh3.ggpht.com/_bLHHR6rd5Ug/Sxn2isijPNI/AAAAAAAAAK8/1oSWhhjB7AI/s1600-h/AlgorithmL20.gif
    # - keep the longest possible initial segment that allows for another permutation;
    # - increase the next item as little as possible;
    # - fill in with the remaining items in increasing order.

    # find the position where element will increase -> rightmost item smaller than next one
    # list = [1, 2, 3, 6, 9, 8, 7, 5, 4]
    # j = 3            ^
    case Enum.find((length(list) - 2)..0, &match?([a, b | _] when a < b, Enum.drop(list, &1))) do
      nil ->
        # last permutation, start again
        Enum.reverse(list)

      j ->
        # {[1, 2, 3], [6 | [9, 8, 7, 5, 4]]}
        {prefix, [pivot | postfix]} = Enum.split(list, j)

        # [4, 5, 7, 8, 9]
        postfix = Enum.reverse(postfix)

        # find next value at position -> smallest value larger than pivot, to the right of pivot
        # {[4, 5], [7 | [8, 9]]}
        {lower, [new_pivot | higher]} = Enum.split_while(postfix, &(&1 < pivot))

        # swap and rebuild (the right part ends up in ascending order)
        # [1, 2, 3] ++ [7] ++ [4, 5] ++ [6] ++ [8, 9]
        # [1, 2, 3, 7, 4, 5, 6, 8, 9]
        prefix ++ [new_pivot] ++ lower ++ [pivot] ++ higher
    end
  end
end

digits =
  ['abcefg', 'cf', 'acdeg', 'acdfg', 'bcdf', 'abdfg', 'abdefg', 'acf', 'abcdefg', 'abcdfg']
  |> Enum.map(&MapSet.new/1)

"input/2021/8.txt"
|> File.read!()
|> String.split(~r"[^a-g]+", trim: true)
|> Enum.map(&String.to_charlist/1)
|> Enum.chunk_every(14)
|> Enum.map(fn line ->
  'abcdefg'
  |> Stream.iterate(&Permutations.next/1)
  |> Stream.map(fn permutation ->
    # apply the permutation to the given list of wires, finding out if they are actually digits
    for digit <- line do
      transformed = MapSet.new(digit, fn c -> Enum.at(permutation, c - ?a) end)
      Enum.find_index(digits, &(&1 == transformed))
    end
  end)
  # find first match (all are digits)
  |> Enum.find(&(!Enum.member?(&1, nil)))
  # drop the control set
  |> Enum.drop(10)
  # rebuild the number
  |> Integer.undigits()
end)
|> Enum.sum()
|> IO.inspect(label: "part 2")
