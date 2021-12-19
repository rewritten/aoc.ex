#! /usr/bin/env elixir

defmodule Bits do
  def parse_text(input) do
    for <<c::8 <- input>>, into: <<>> do
      <<if(c in ?A..?F, do: c - ?A + 10, else: c - ?0)::4>>
    end
    |> parse()
    |> elem(0)
  end

  def version_sum(%{v: v, p: p}), do: v + (p |> Enum.map(&version_sum/1) |> Enum.sum())
  def version_sum(%{v: v}), do: v

  def eval(%{lit: lit}), do: lit
  def eval(%{op: 0, p: p}), do: p |> Enum.map(&eval/1) |> Enum.sum()
  def eval(%{op: 1, p: p}), do: p |> Enum.map(&eval/1) |> Enum.reduce(&Kernel.*/2)
  def eval(%{op: 2, p: p}), do: p |> Enum.map(&eval/1) |> Enum.min()
  def eval(%{op: 3, p: p}), do: p |> Enum.map(&eval/1) |> Enum.max()
  def eval(%{op: 5, p: [p, q]}), do: if(eval(p) > eval(q), do: 1, else: 0)
  def eval(%{op: 6, p: [p, q]}), do: if(eval(p) < eval(q), do: 1, else: 0)
  def eval(%{op: 7, p: [p, q]}), do: if(eval(p) == eval(q), do: 1, else: 0)

  defp parse(""), do: nil

  # literal number
  defp parse(<<v::size(3), 4::size(3), rest::bitstring>>) do
    {hexits, rest} = lit(rest)
    {%{v: v, lit: Integer.undigits(hexits, 16)}, rest}
  end

  # operator with explicit tokens length
  defp parse(<<v::size(3), op::size(3), 0::1, length::15, rest::bitstring>>) do
    <<data::size(length), rest::bitstring>> = rest
    p = <<data::size(length)>> |> Stream.unfold(&parse/1) |> Enum.to_list()
    {%{v: v, op: op, p: p}, rest}
  end

  # operator with number of tokens
  defp parse(<<v::size(3), op::size(3), 1::1, length::11, rest::bitstring>>) do
    {p, rest} = Enum.map_reduce(1..length, rest, fn _, bits -> parse(bits) end)
    {%{v: v, op: op, p: p}, rest}
  end

  defp lit(<<0::1, c::4, rest::bitstring>>), do: {[c], rest}
  defp lit(<<1::1, c::4, rest::bitstring>>), do: with({d, rest} <- lit(rest), do: {[c | d], rest})
end

ast =
  "input/2021/16.txt"
  |> File.read!()
  |> String.trim()
  |> Bits.parse_text()

ast
|> Bits.version_sum()
|> IO.inspect(label: "part 1")

ast
|> Bits.eval()
|> IO.inspect(label: "part 2")
