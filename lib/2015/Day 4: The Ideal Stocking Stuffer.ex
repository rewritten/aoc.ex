defmodule Aoc.TheIdealStockingStuffer do
  def solve(1, text) do
    text = String.trim(text)

    1
    |> Stream.iterate(&(&1 + 1))
    |> Enum.find(fn n ->
      match?(<<0, 0, x, _::binary>> when x < 16, :erlang.md5(text <> inspect(n)))
    end)
  end

  def solve(2, text) do
    text = String.trim(text)

    1
    |> Stream.iterate(&(&1 + 1))
    |> Enum.find(fn n -> match?(<<0, 0, 0, _::binary>>, :erlang.md5(text <> inspect(n))) end)
  end
end
