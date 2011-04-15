#!/usr/bin/env ruby

require "maze"

i = 1
e = nil
loop do
  maze = Maze.new(i, e)
  maze.fetch
  maze.construct
  maze.solve
  maze.respond
  $stderr.puts ">>> #{maze.id}: #{maze.success} <<<"
  exit if !maze.success
  File.open("tmp/solution_#{maze.id}", "w+") { |f| f << maze.solution }
  e  = maze.expiry
  i += 1
end
