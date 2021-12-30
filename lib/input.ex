defmodule Input do
  def matrix(input, value_fn \\ & &1) do
    for line <- l(input) do
      for c <- String.to_charlist(line) do
        value_fn.(c)
      end
    end
  end

  def sparse_matrix(input, value_fn \\ & &1, filter_fn \\ fn _ -> true end) do
    for {line, i} <- input |> String.split("\n", trim: true) |> Enum.with_index(),
        {c, j} <- line |> String.to_charlist() |> Enum.with_index(),
        filter_fn.(c),
        val = value_fn.(c),
        into: %{} do
      {{i, j}, val}
    end
  end

  def i(text) do
    ~r"-?\d+" |> Regex.scan(text) |> Enum.map(fn [n] -> String.to_integer(n) end)
  end

  def l(text, options \\ []) when is_list(options) do
    ls = String.split(text, "\n", trim: true)

    options
    |> Enum.reduce(ls, fn
      {:map, :w}, acc -> Enum.map(acc, &w/1)
      {:map, :i}, acc -> Enum.map(acc, &i/1)
      {:map, f}, acc when is_function(f, 1) -> Enum.map(acc, f)
      {:fmap, f}, acc when is_function(f, 1) -> Enum.map(acc, &Enum.map(&1, f))
    end)
  end

  def p(text), do: String.split(text, "\n\n", trim: true)
  def w(text), do: String.split(text, ~r"\W+", trim: true)
end
