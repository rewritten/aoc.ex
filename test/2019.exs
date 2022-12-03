defmodule AocTest do
  use ExUnit.Case
  import AocTest.Macros

  describe "Day 2: 1202 Program Alarm" do
    @describetag mod: Aoc.Z1202ProgramAlarm, input: File.read!("input/2019/2.txt")

    test! part: 1, expected: 5_110_675
    test! part: 2, expected: 4847
  end

  describe "Day 5: Sunny with a Chance of Asteroids" do
    @describetag mod: Aoc.SunnyWithAChanceOfAsteroids, input: File.read!("input/2019/5.txt")

    test! part: 1, expected: 7_839_346
    test! part: 2, expected: 447_803
  end

  describe "Day 7: Amplification Circuit" do
    @describetag mod: Aoc.AmplificationCircuit, input: File.read!("input/2019/7.txt")

    test! part: 1, expected: 914_828
    test! part: 2, expected: 17_956_613
  end

  describe "Day 9: Sensor Boost" do
    @describetag mod: Aoc.SensorBoost, input: File.read!("input/2019/9.txt")

    test! part: 1, expected: 3_989_758_265
    test! part: 2, expected: 76791
  end

  describe "Day 11: Space Police" do
    @describetag mod: Aoc.SpacePolice, input: File.read!("input/2019/11.txt")

    test! part: 1, expected: 0
    test! part: 2, expected: 0
  end
end
