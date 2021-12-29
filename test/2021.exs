defmodule AocTest do
  use ExUnit.Case
  import AocTest.Macros

  describe "Day 1: Sonar Sweep" do
    @describetag mod: Aoc.SonarSweep, input: File.read!("input/2021/1.txt")

    test! part: 1, expected: 1228
    test! part: 2, expected: 1257
  end

  describe "Day 2: Dive!" do
    @describetag mod: Aoc.Dive, input: File.read!("input/2021/2.txt")

    test! part: 1, expected: 1_499_229
    test! part: 2, expected: 1_340_836_560
  end

  describe "Day 3: Binary Diagnostic" do
    @describetag mod: Aoc.BinaryDiagnostic, input: File.read!("input/2021/3.txt")

    test! part: 1, expected: 3_912_944
    test! part: 2, expected: 4_996_233
  end

  describe "Day 4: Giant Squid" do
    @describetag mod: Aoc.GiantSquid, input: File.read!("input/2021/4.txt")

    test! part: 1, expected: 27027
    test! part: 2, expected: 36975
  end

  describe "Day 5: Hydrothermal Venture" do
    @describetag mod: Aoc.HydrothermalVenture, input: File.read!("input/2021/5.txt")

    test! part: 1, expected: 5442
    test! part: 2, expected: 19571
  end

  describe "Day 6: Lanternfish" do
    @describetag mod: Aoc.Lanternfish, input: File.read!("input/2021/6.txt")

    test! part: 1, expected: 393_019
    test! part: 2, expected: 1_757_714_216_975
  end

  describe "Day 7: The Treachery of Whales" do
    @describetag mod: Aoc.TheTreacheryOfWhales, input: File.read!("input/2021/7.txt")

    test! part: 1, expected: 352_254
    test! part: 2, expected: 99_053_143
  end

  describe "Day 8: Seven Segment Search" do
    @describetag mod: Aoc.SevenSegmentSearch, input: File.read!("input/2021/8.txt")

    test! part: 1, expected: 237
    test! part: 2, expected: 1_009_098
  end

  describe "Day 9: Smoke Basin" do
    @describetag mod: Aoc.SmokeBasin, input: File.read!("input/2021/9.txt")

    test! part: 1, expected: 504
    test! part: 2, expected: 1_558_722
  end

  describe "Day 10: Syntax Scoring" do
    @describetag mod: Aoc.SyntaxScoring, input: File.read!("input/2021/10.txt")

    test! part: 1, expected: 216_297
    test! part: 2, expected: 2_165_057_169
  end

  describe "Day 11: Dumbo Octopus" do
    @describetag mod: Aoc.DumboOctopus, input: File.read!("input/2021/11.txt")

    test! part: 1, expected: 1743
    test! part: 2, expected: 364
  end

  describe "Day 12: Passage Pathing" do
    @describetag mod: Aoc.PassagePathing, input: File.read!("input/2021/12.txt")

    test! part: 1, expected: 3369
    test! part: 2, expected: 85883
  end

  describe "Day 13: Transparent Origami" do
    @describetag mod: Aoc.TransparentOrigami, input: File.read!("input/2021/13.txt")

    test! part: 1, expected: 788

    test! part: 2,
          expected: """
          #  #   ## ###  #  # #### #  # ###   ##
          # #     # #  # # #  #    #  # #  # #  #
          ##      # ###  ##   ###  #  # ###  #
          # #     # #  # # #  #    #  # #  # # ##
          # #  #  # #  # # #  #    #  # #  # #  #
          #  #  ##  ###  #  # ####  ##  ###   ###
          """
  end

  describe "Day 14: Extended Polymerization" do
    @describetag mod: Aoc.ExtendedPolymerization, input: File.read!("input/2021/14.txt")

    test! part: 1, expected: 3906
    test! part: 2, expected: 4_441_317_262_452
  end

  describe "Day 15: Chiton" do
    @describetag mod: Aoc.Chiton, input: File.read!("input/2021/15.txt")

    test! part: 1, expected: 707
    test! part: 2, expected: 2942
  end

  describe "Day 16: Packet Decoder" do
    @describetag mod: Aoc.PacketDecoder, input: File.read!("input/2021/16.txt")

    test! part: 1, expected: 977
    test! part: 2, expected: 101_501_020_883
  end

  describe "Day 17: Trick Shot" do
    @describetag mod: Aoc.TrickShot, input: File.read!("input/2021/17.txt")

    test! part: 1, expected: 4186
    test! part: 2, expected: 2709
  end

  describe "Day 18: Snailfish" do
    @describetag mod: Aoc.Snailfish, input: File.read!("input/2021/18.txt")

    test! part: 1, expected: 2907
    test! part: 2, expected: 4690
  end
end
