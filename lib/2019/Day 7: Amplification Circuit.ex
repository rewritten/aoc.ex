defmodule Aoc.AmplificationCircuit do
  def solve(1, text) do
    data = Input.i(text)

    10..14
    |> Enum.map(fn i -> data |> Enum.drop(Enum.at(data, i)) |> compile() end)
    |> Perm.permutations()
    |> Enum.map(fn perm -> perm |> List.flatten() |> Enum.reduce(0, & &1.(&2)) end)
    |> Enum.max()
  end

  def solve(2, text) do
    data = Input.i(text)

    15..19
    |> Enum.map(fn i -> data |> Enum.drop(Enum.at(data, i)) |> compile() end)
    |> Perm.permutations()
    |> Enum.map(fn perm -> perm |> Enum.zip_with(& &1) end)
    |> Enum.map(fn perm -> perm |> List.flatten() |> Enum.reduce(0, & &1.(&2)) end)
    |> Enum.max()
  end

  defp compile([101, a, n, n | rest]), do: [(&(&1 + a)) | compile(rest)]
  defp compile([102, a, n, n | rest]), do: [(&(&1 * a)) | compile(rest)]
  defp compile([1001, n, a, n | rest]), do: [(&(&1 + a)) | compile(rest)]
  defp compile([1002, n, a, n | rest]), do: [(&(&1 * a)) | compile(rest)]
  defp compile([]), do: []
  defp compile([99 | _]), do: []
  defp compile([_ | rest]), do: compile(rest)
end
