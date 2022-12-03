defmodule Aoc.SensorBoost do
  def solve(n, text) do
    {:ok, op} = text |> Input.i() |> Aoc.Opcode.start()
    Aoc.Opcode.run(op)
    Aoc.Opcode.input(op, n)
    Aoc.Opcode.diagnostic(op)
  end
end
