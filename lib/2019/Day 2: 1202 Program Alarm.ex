defmodule Aoc.Z1202ProgramAlarm do
  def solve(1, text) do
    [z, _, _ | rest] = Input.i(text)
    {:ok, op} = Aoc.Opcode.start([z, 12, 2 | rest])
    Aoc.Opcode.run(op)
    Aoc.Opcode.at_zero(op)
  end

  def solve(2, text) do
    [z, _, _ | rest] = Input.i(text)

    for x <- 0..99, y <- 0..99 do
      {:ok, op} = Aoc.Opcode.start([z, x, y | rest])

      Task.async(fn ->
        Aoc.Opcode.run(op)

        if Aoc.Opcode.at_zero(op) == 19_690_720 do
          x * 100 + y
        else
          nil
        end
      end)
    end
    |> Task.await_many()
    |> Enum.find(&(!is_nil(&1)))
  end
end
