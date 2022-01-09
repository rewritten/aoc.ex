defmodule Perm do
  @doc """
  ## Examples

      iex> [2, 4, 3] |> Perm.permutations() |> Enum.to_list()
      [[2, 4, 3], [3, 2, 4], [3, 4, 2], [4, 2, 3], [4, 3, 2], [2, 3, 4]]
  """
  def permutations(list) do
    others = list |> Stream.iterate(&next/1) |> Stream.drop(1) |> Stream.take_while(&(&1 != list))

    Stream.concat([list], others)
  end

  @doc ~S"""
  Return the "next" lexicographic permutation of list.
  http://lh3.ggpht.com/_bLHHR6rd5Ug/Sxn2isijPNI/AAAAAAAAAK8/1oSWhhjB7AI/s1600-h/AlgorithmL20.gif

  ## Examples

      iex> Perm.next([1, 3, 4])
      [1, 4, 3]
      iex> Perm.next([3, 4, 1])
      [4, 1, 3]
  """
  def next(list) do
    0..(length(list) - 2)
    |> Enum.reverse()
    |> Enum.find(&(Enum.at(list, &1) < Enum.at(list, &1 + 1)))
    |> case do
      nil ->
        Enum.reverse(list)

      j ->
        {prefix, [pivot | postfix]} = Enum.split(list, j)
        postfix = Enum.reverse(postfix)
        {lower, [new_pivot | higher]} = Enum.split_while(postfix, &(&1 < pivot))
        prefix ++ [new_pivot] ++ lower ++ [pivot] ++ higher
    end
  end
end
