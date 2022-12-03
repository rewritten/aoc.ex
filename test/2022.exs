defmodule AocTest do
  use ExUnit.Case
  import AocTest.Macros

  describe "Day 1: Calorie Counting" do
    @describetag mod: Aoc.CalorieCounting, input: File.read!("input/2022/1.txt")

    test! part: 1, expected: 74394
    test! part: 2, expected: 212_836
  end

  describe "Day 2: Rock Paper Scissors" do
    @describetag mod: Aoc.RockPaperScissors, input: File.read!("input/2022/2.txt")

    test! part: 1, expected: 9241
    test! part: 2, expected: 14610
  end

  describe "Day 3: Rucksack Reorganization" do
    @describetag mod: Aoc.RucksackReorganization, input: File.read!("input/2022/3.txt")

    test! part: 1, expected: 7824
    test! part: 2, expected: 2798
  end
end
