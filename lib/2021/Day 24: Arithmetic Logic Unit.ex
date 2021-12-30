defmodule Aoc.ArithmeticLogicUnit do
  @moduledoc """
  This problem became extremely fast as soon as a regularity on the instructions
  is found.

  The full instruction list is composed by 14 subsequent blocks of 18
  instructions, each starting with "inp w". All blocks are equal except for
  three positions, at position 4 there can be "div z 1" or "div z 26", at
  position 5 there can be "add x _", and at position 15 there can be "add y _".
  We will call these two numbers _A_ and _B_.

  Additionally, every instruction "div z 26" is followed by "add x (0 or negative)",
  and every instruction "div z 1" is followed by "add x (positive > 10)", and
  there are 7 of each.

  We can already swap "z as a number" with "z as a stack of digits" (in base 26,
  with the least significant digit on the top of the stack), so 51 would be
  [25, 1].

  Each block of instructions is then either (for case "div z 1")

  * Read one digit from input into _w_.
  * Set _x_ to hd(_z_) + _A_, which is greater than 10.
  * Compare _x_ with _w_, they cannot be equal as _w_ <= 9.
  * __Push__ to _z_ the number _w_ + _B_.

  or (for case "div z 26")

  * Read one digit from input into _w_.
  * Set _x_ to hd(_z_) + _A_, this time _A_ is 0 or negative.
  * Set _z_ to tl(_z_), that is, __pop__ the stack.
  * Compare _x_ with _w_.
  * If they are different, __push__ to _z_ the number _w_ + _B_.

  So the first case always increases the stack by 1, and the second case
  decreases only if _x_ happened to be equal to _w_. For the final result to
  be 0 (an empty stack), we need every pop to happen, that is, every time we
  comp are _x_ with _w_ in a "div z 26", they must be equal.

  The instructions
  ```
  div z 1   add x 14   add y 12
  div z 1   add x 15   add y 7
  div z 1   add x 12   add y 1
  div z 1   add x 11   add y 2
  div z 26  add x -5   add y 4
  div z 1   add x 14   add y 15
  div z 1   add x 15   add y 11
  div z 26  add x -13  add y 5
  div z 26  add x -16  add y 3
  div z 26  add x -8   add y 9
  div z 1   add x 15   add y 2
  div z 26  add x -8   add y 3
  div z 1   add x 0    add y 3
  div z 26  add x -4   add y 11
  ```

  becomes
  ```
  push(read() + 12)
  push(read() + 7)
  push(read() + 1)
  push(read() + 2)
  assert pop() + -5 == read()
  push(read() + 15)
  push(read() + 11)
  assert pop() + -13 == read()
  assert pop() + -16 == read()
  assert pop() + -8 == read()
  push(read() + 2)
  assert pop() + -8 == read()
  assert pop() + 0 == read()
  assert pop() + -4 == read()
  ```

  The order of pushes and pops is now determined, and we can set up the right
  constraints for the assertions. In this example, we have (just taking from the
  7th and the 8th line) `assert d[6] + 11 - 13 == d[7]`.

  In order to pair correctly the positions to push and pop, I group the
  operations by the height at which they operate at, and then take them in pairs
  among those with the same level.

  ```
  level: 1, idx: 0,  push(read() + 12)
  level: 2, idx: 1,  push(read() + 7)
  level: 3, idx: 2,  push(read() + 1)
  level: 4, idx: 3,  push(read() + 2)
  level: 4, idx: 4,  assert pop() + -5 == read()
  level: 4, idx: 5,  push(read() + 15)
  level: 5, idx: 6,  push(read() + 11)
  level: 5, idx: 7,  assert pop() + -13 == read()
  level: 4, idx: 8,  assert pop() + -16 == read()
  level: 3, idx: 9,  assert pop() + -8 == read()
  level: 3, idx: 10, push(read() + 2)
  level: 3, idx: 11, assert pop() + -8 == read()
  level: 2, idx: 12, assert pop() + 0 == read()
  level: 1, idx: 13, assert pop() + -4 == read()
  ```

  sorted and grouped into:

  ```
  level: 1, idx: 0,  push(read() + 12)
  level: 1, idx: 13, assert pop() + -4 == read()
  -> assert d[0] + 12 - 4 == d[13]

  level: 2, idx: 1,  push(read() + 7)
  level: 2, idx: 12, assert pop() + 0 == read()
  -> assert d[1] + 7 == d[12]

  level: 3, idx: 2,  push(read() + 1)
  level: 3, idx: 9,  assert pop() + -8 == read()
  -> assert d[2] + 1 - 8 == d[9]

  level: 3, idx: 10, push(read() + 2)
  level: 3, idx: 11, assert pop() + -8 == read()
  -> assert d[10] + 2 - 8 == d[11]

  level: 4, idx: 3,  push(read() + 2)
  level: 4, idx: 4,  assert pop() + -5 == read()
  -> assert d[3] + 2 - 5 == d[4]

  level: 4, idx: 5,  push(read() + 15)
  level: 4, idx: 8,  assert pop() + -16 == read()
  -> assert d[5] + 15 - 16 == d[8]

  level: 5, idx: 6,  push(read() + 11)
  level: 5, idx: 7,  assert pop() + -13 == read()
  -> assert d[6] + 11 - 13 == d[7]
  ```

  In my understanding, the puzzle needs the above constraints to be solvable,
  and different input vary on the specific order of pushes and pops, and the
  relative differences between the _A_s and the _B_s.
  """
  def solve(1, text) do
    text
    |> parse()
    |> Enum.flat_map(fn
      {left, right, d} when d >= 0 -> [{left, 9 - d}, {right, 9}]
      {left, right, d} when d < 0 -> [{left, 9}, {right, 9 + d}]
    end)
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Integer.undigits()
  end

  def solve(2, text) do
    text
    |> parse()
    |> Enum.flat_map(fn
      {left, right, d} when d >= 0 -> [{left, 1}, {right, 1 + d}]
      {left, right, d} when d < 0 -> [{left, 1 - d}, {right, 1}]
    end)
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Integer.undigits()
  end

  # Return a list of {position, position, difference}, that indicates the
  # necessary difference between digits at the given positions.
  defp parse(text) do
    text
    |> Input.l()
    |> Enum.chunk_every(18)
    |> Enum.map_reduce(0, fn block, level ->
      [a] = block |> Enum.at(5) |> Input.i()
      [b] = block |> Enum.at(15) |> Input.i()
      if a > 0, do: {{level + 1, b}, level + 1}, else: {{level, a}, level - 1}
    end)
    |> elem(0)
    |> Enum.with_index(fn {level, x}, i -> {level, i, x} end)
    |> Enum.sort()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [{_, left, y}, {_, right, x}] -> {left, right, x + y} end)
  end
end
