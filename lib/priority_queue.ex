defmodule PriorityQueue do
  def new(), do: %{}

  def _in(%{} = this, cost, node) do
    this
    |> Map.put_new_lazy(cost, &:queue.new/0)
    |> Map.update!(cost, &:queue.in(node, &1))
  end

  def out(%{} = this) do
    cost = this |> Map.keys() |> Enum.min(fn -> nil end)
    {{:value, item}, q2} = this |> Map.get(cost) |> :queue.out()

    if :queue.is_empty(q2) do
      {cost, item, Map.delete(this, cost)}
    else
      {cost, item, Map.put(this, cost, q2)}
    end
  end
end
