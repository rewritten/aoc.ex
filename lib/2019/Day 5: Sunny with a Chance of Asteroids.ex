defmodule Aoc.SunnyWithAChanceOfAsteroids do
  def solve(1, text) do
    data = Input.i(text)
    {:ok, opcode} = Aoc.Opcode.start(data)
    Aoc.Opcode.run(opcode)
    Aoc.Opcode.input(opcode, 1)
    Aoc.Opcode.diagnostic(opcode)
  end

  def solve(2, text) do
    data = Input.i(text)
    {:ok, opcode} = Aoc.Opcode.start(data)
    Aoc.Opcode.run(opcode)
    Aoc.Opcode.input(opcode, 5)
    Aoc.Opcode.diagnostic(opcode)
  end
end
