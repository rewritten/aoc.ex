defmodule Aoc.SeaCucumber do
  def solve(1, text) do
    text
    |> Input.sparse_matrix(& &1, &(&1 in 'v>'))
    |> Enum.group_by(fn {_, v} -> v end, fn {k, _} -> k end)
    |> Map.map(fn {_, v} -> MapSet.new(v) end)
    |> Stream.iterate(&move/1)
    |> Stream.chunk_every(2, 1)
    |> Stream.take_while(fn [a, b] -> a != b end)
    |> Enum.count()
    |> Kernel.+(1)
  end

  defp move(%{?> => eastbound, ?v => southbound}) do
    eastbound =
      for {i, j} <- eastbound,
          destination = {i, rem(j + 1, 139)},
          not MapSet.member?(eastbound, destination),
          not MapSet.member?(southbound, destination),
          reduce: eastbound do
        s -> s |> MapSet.delete({i, j}) |> MapSet.put(destination)
      end

    southbound =
      for {i, j} <- southbound,
          destination = {rem(i + 1, 137), j},
          not MapSet.member?(eastbound, destination),
          not MapSet.member?(southbound, destination),
          reduce: southbound do
        s -> s |> MapSet.delete({i, j}) |> MapSet.put(destination)
      end

    %{?> => eastbound, ?v => southbound}
  end
end
