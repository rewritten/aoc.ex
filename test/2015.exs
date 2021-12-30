defmodule AocTest do
  use ExUnit.Case
  import AocTest.Macros

  describe "Day 1: Not Quite Lisp" do
    @describetag mod: Aoc.NotQuiteLisp, input: File.read!("input/2015/1.txt")

    test! part: 1, expected: 232
    test! part: 2, expected: 1783
  end

  describe "Day 2: I Was Told There Would Be No Math" do
    @describetag mod: Aoc.IWasToldThereWouldBeNoMath, input: File.read!("input/2015/2.txt")

    test! part: 1, expected: 1_586_300
    test! part: 2, expected: 3_737_498
  end

  describe "Day 3: Perfectly Spherical Houses in a Vacuum" do
    @describetag mod: Aoc.PerfectlySphericalHousesInAVacuum, input: File.read!("input/2015/3.txt")

    test! part: 1, expected: 2565
    test! part: 2, expected: 2639
  end

  describe "Day 4: The Ideal Stocking Stuffer" do
    @describetag mod: Aoc.TheIdealStockingStuffer, input: File.read!("input/2015/4.txt")

    test! part: 1, expected: 117_946

    @tag :slow
    test! part: 2, expected: 3_938_038
  end

  describe "Day 5: Doesn't He Have Intern-Elves For This?" do
    @describetag mod: Aoc.DoesntHeHaveInternElvesForThis, input: File.read!("input/2015/5.txt")

    test! part: 1, expected: 258
    test! part: 2, expected: 53
  end

  describe "Day 6: Probably a Fire Hazard" do
    @describetag mod: Aoc.ProbablyAFireHazard, input: File.read!("input/2015/6.txt")
    @describetag :slow

    test! part: 1, expected: 377_891
    test! part: 2, expected: 14_110_788
  end

  describe "Day 7: Some Assembly Required" do
    @describetag mod: Aoc.SomeAssemblyRequired, input: File.read!("input/2015/7.txt")

    test! part: 1, expected: 3176
    test! part: 2, expected: 14710
  end

  describe "Day 8: Matchsticks" do
    @describetag mod: Aoc.Matchsticks, input: File.read!("input/2015/8.txt")

    test! part: 1, expected: 1371
    test! part: 2, expected: 2117
  end
end
