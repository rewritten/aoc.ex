defmodule Dijkstra do
  def shortest_path(start, neighbors_fn, finish_condition) do
    pq = PriorityQueue.new() |> PriorityQueue._in(0, start)
    visited = MapSet.new()

    Stream.unfold({pq, visited}, fn {queue, visited} ->
      {current_cost, node, queue} = PriorityQueue.out(queue)

      if MapSet.member?(visited, node) do
        {nil, {queue, visited}}
      else
        queue =
          for {cost, neighbor} <- neighbors_fn.(node),
              !MapSet.member?(visited, neighbor),
              reduce: queue do
            pq -> PriorityQueue._in(pq, cost + current_cost, neighbor)
          end

        visited = MapSet.put(visited, node)

        {{current_cost, node}, {queue, visited}}
      end
    end)
    |> Stream.drop(1)
    |> Stream.reject(&is_nil/1)
    |> Enum.find(finish_condition)
  end
end
