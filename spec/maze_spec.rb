#!/usr/bin/env ruby

require "minitest/autorun"
require "maze"

describe Maze do
  before do
    @maze = Maze.new(1)
    data = File.read("mazes/maze_1")
    @maze.data = Yajl::Parser.parse(data)
    @maze.construct
  end

  it "find in and out" do
    @maze.in.must_equal [1, 0]
  end

  it "fetches a square" do
    @maze.square(0,0).must_equal "#"
    @maze.square(0,1).must_equal "#"
    @maze.square(1,0).must_equal "I"
    @maze.square(1,1).must_equal "O"
  end

  it "counts rows and columns" do
    @maze.nb_rows.must_equal 2
    @maze.nb_columns.must_equal 3
  end

  it "calculates the next square of a given position" do
    @maze.north(0, 1).must_equal [0, 0]
    @maze.south(0, 1).must_equal [0, 2]
    @maze.east(0, 1).must_equal [1, 1]
    @maze.west(0, 1).must_equal [-1, 1]
  end

  it "knows if we can move to a square" do
    @maze.can_move_to?(1, 0).must_equal true
    @maze.can_move_to?(1, 1).must_equal true
    @maze.can_move_to?(2, 1).must_equal false
    @maze.can_move_to?(0, 1).must_equal false
    @maze.can_move_to?(2, 2).must_equal false
  end

  it "solve the first maze" do
    @maze.solve
    @maze.solution.must_equal "S"
  end

  it "solve the second maze" do
    maze = Maze.new(2)
    data = File.read("mazes/maze_2")
    maze.data = Yajl::Parser.parse(data)
    maze.construct
    maze.solve
    maze.solution.must_equal "E"
  end

  it "solve the third maze" do
    maze = Maze.new(3)
    data = File.read("mazes/maze_3")
    maze.data = Yajl::Parser.parse(data)
    maze.construct
    maze.solve
    maze.solution.must_equal "N"
  end

end
