defmodule Aoc.PacketDecoder do
  def solve(1, input), do: input |> parse() |> version_sum()
  def solve(2, input), do: input |> parse() |> eval()

  defp parse(text) do
    for <<c::8 <- text>>, c != ?\n, into: <<>> do
      <<if(c in ?A..?F, do: c - ?A + 10, else: c - ?0)::4>>
    end
    |> parse_stream()
    |> elem(0)
  end

  defp version_sum(%{v: v, p: p}), do: v + (p |> Enum.map(&version_sum/1) |> Enum.sum())
  defp version_sum(%{v: v}), do: v

  defp eval(%{lit: lit}), do: lit
  defp eval(%{op: 0, p: p}), do: p |> Enum.map(&eval/1) |> Enum.sum()
  defp eval(%{op: 1, p: p}), do: p |> Enum.map(&eval/1) |> Enum.reduce(&Kernel.*/2)
  defp eval(%{op: 2, p: p}), do: p |> Enum.map(&eval/1) |> Enum.min()
  defp eval(%{op: 3, p: p}), do: p |> Enum.map(&eval/1) |> Enum.max()
  defp eval(%{op: 5, p: [p, q]}), do: if(eval(p) > eval(q), do: 1, else: 0)
  defp eval(%{op: 6, p: [p, q]}), do: if(eval(p) < eval(q), do: 1, else: 0)
  defp eval(%{op: 7, p: [p, q]}), do: if(eval(p) == eval(q), do: 1, else: 0)

  defp parse_stream(""), do: nil

  # literal number
  defp parse_stream(<<v::3, 4::3, rest::bitstring>>) do
    {hexits, rest} = lit(rest)
    {%{v: v, lit: Integer.undigits(hexits, 16)}, rest}
  end

  # operator with explicit tokens length
  defp parse_stream(<<v::3, op::3, 0::1, length::15, rest::bitstring>>) do
    <<data::size(length), rest::bitstring>> = rest
    p = <<data::size(length)>> |> Stream.unfold(&parse_stream/1) |> Enum.to_list()
    {%{v: v, op: op, p: p}, rest}
  end

  # operator with number of tokens
  defp parse_stream(<<v::3, op::3, 1::1, length::11, rest::bitstring>>) do
    {p, rest} = Enum.map_reduce(1..length, rest, fn _, bits -> parse_stream(bits) end)
    {%{v: v, op: op, p: p}, rest}
  end

  defp lit(<<0::1, c::4, rest::bitstring>>), do: {[c], rest}
  defp lit(<<1::1, c::4, rest::bitstring>>), do: with({d, rest} <- lit(rest), do: {[c | d], rest})
end
