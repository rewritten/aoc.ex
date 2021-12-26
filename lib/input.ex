defmodule Input do
  def matrix(input, value_fn \\ & &1) do
    for line <- String.split(input, "\n", trim: true) do
      for c <- String.to_charlist(line) do
        value_fn.(c)
      end
    end
  end

  def sparse_matrix(input, value_fn \\ & &1) do
    for {line, i} <- input |> String.split("\n", trim: true) |> Enum.with_index(),
        {c, j} <- line |> String.to_charlist() |> Enum.with_index(),
        val = value_fn.(c),
        into: %{} do
      {{i, j}, val}
    end
  end
end
