#! /usr/bin/env elixir

"input/2021/8.txt"
|> File.read!()
|> String.split(~r"[^a-g]+", trim: true)
|> Enum.map(&String.to_charlist/1)
|> Enum.chunk_every(14)
|> Enum.map(fn line ->
  'abcdefg'
  |> Stream.iterate(fn list ->
    # return the "next" lexicographic permutation of list.
    # http://lh3.ggpht.com/_bLHHR6rd5Ug/Sxn2isijPNI/AAAAAAAAAK8/1oSWhhjB7AI/s1600-h/AlgorithmL20.gif

    # find the position where element will increase -> rightmost item smaller than next one
    j =
      0..(length(list) - 2)
      |> Enum.reverse()
      |> Enum.find(&(Enum.at(list, &1) < Enum.at(list, &1 + 1)))

    {prefix, [pivot | postfix]} = Enum.split(list, j)
    postfix = Enum.reverse(postfix)
    # find next value at position -> smallest value larger than pivot, to the right of pivot
    {lower, [new_pivot | higher]} = Enum.split_while(postfix, &(&1 < pivot))
    # swap and rebuild (the right part is sorted ascending)
    prefix ++ [new_pivot] ++ lower ++ [pivot] ++ higher
  end)
  |> Stream.map(fn permutation ->
    # apply the permutation to the given list of wires, finding out if they are actually digits
    for digit <- line do
      digit
      |> Enum.map(fn c -> Enum.at(permutation, c - ?a) end)
      |> Enum.sort()
      |> then(fn
        'abcefg' -> 0
        'cf' -> 1
        'acdeg' -> 2
        'acdfg' -> 3
        'bcdf' -> 4
        'abdfg' -> 5
        'abdefg' -> 6
        'acf' -> 7
        'abcdefg' -> 8
        'abcdfg' -> 9
        _ -> nil
      end)
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
