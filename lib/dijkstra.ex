defmodule Dijkstra do
  defmodule PQ do
    defstruct nodes: %{}

    def new(), do: %PQ{}

    def _in(%PQ{} = this, cost, node) do
      nodes =
        this.nodes
        |> Map.put_new_lazy(cost, &:queue.new/0)
        |> Map.update!(cost, &:queue.in(node, &1))

      %{this | nodes: nodes}
    end

    def out(%PQ{nodes: nodes} = this) do
      cost = nodes |> Map.keys() |> Enum.min(fn -> nil end)
      {{:value, item}, q2} = nodes |> Map.get(cost) |> :queue.out()
      nodes = if :queue.is_empty(q2), do: Map.delete(nodes, cost), else: Map.put(nodes, cost, q2)
      {cost, item, %{this | nodes: nodes}}
    end
  end

  def shortest_path(start, neighbors_fn, finish_condition) do
    pq = PQ.new() |> PQ._in(0, start)
    visited = MapSet.new()

    Stream.unfold({pq, visited}, fn {queue, visited} ->
      {current_cost, node, queue} = PQ.out(queue)

      if MapSet.member?(visited, node) do
        {nil, {queue, visited}}
      else
        queue =
          for {cost, neighbor} <- neighbors_fn.(node),
              !MapSet.member?(visited, neighbor),
              reduce: queue do
            pq -> PQ._in(pq, cost + current_cost, neighbor)
          end

        visited = MapSet.put(visited, node)

        {{current_cost, node}, {queue, visited}}
      end
    end)
    |> Stream.reject(&is_nil/1)
    |> Enum.find(finish_condition)
  end
end

defmodule DijkstraEts do
  defmodule PQ do
    defstruct nodes: %{}

    def new(), do: :ets.new(:pq, [:ordered_set])

    def _in(tid, cost, node) do
      case :ets.lookup(tid, cost) do
        [{_, q}] -> :ets.insert(tid, {cost, :queue.in(node, q)})
        [] -> :ets.insert(tid, {cost, :queue.from_list([node])})
      end

      tid
    end

    def out(tid) do
      cost = :ets.first(tid)
      [{cost, q}] = :ets.lookup(tid, cost)
      {{:value, item}, q2} = :queue.out(q)
      if :queue.is_empty(q2), do: :ets.delete(tid, cost), else: :ets.insert(tid, {cost, q2})
      {cost, item}
    end
  end

  def shortest_path(start, neighbors_fn, finish_condition) do
    queue = PQ.new()

    PQ._in(queue, 0, start)

    Stream.unfold(MapSet.new(), fn visited ->
      {current_cost, node} = PQ.out(queue)

      if MapSet.member?(visited, node) do
        {nil, visited}
      else
        for {cost, neighbor} <- neighbors_fn.(node),
            !MapSet.member?(visited, neighbor) do
          PQ._in(queue, cost + current_cost, neighbor)
        end

        {{current_cost, node}, MapSet.put(visited, node)}
      end
    end)
    |> Stream.reject(&is_nil/1)
    |> Enum.find(finish_condition)
  end
end
