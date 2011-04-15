require 'yajl'

class Maze
  attr_accessor :data, :id, :expiry, :success, :in, :out, :solution

  KEY = File.read(".key").chomp

  def initialize(id, expiry=nil)
    @id = id
    @expiry = expiry
  end

  def fetch
    e = expiry ? "&expiry=#{@expiry}" : ""
    out = `curl http://beta.agilecup.org/problem/#{"%02d" % @id}?key=#{KEY}#{e}`
    File.open("tmp/problem_#{@id}", "w+") { |f| f << out }
    @data = Yajl::Parser.parse(out)
  end

  def respond
    e = expiry ? "&expiry=#{@expiry}" : ""
    out = `curl -X POST -d "key=#{KEY}&solution=#{@solution}#{e}" http://beta.agilecup.org/solution/#{"%02d" % @id}`
    File.open("tmp/out_#{@id}", "w+") { |f| f << out }
    d = Yajl::Parser.parse(out)
    @success = d["success"] == "ok"
    @expiry = d["expiry"]
  end

  def construct
    @rows = @data.split("\n")

    # Find in and out
    @rows.each.with_index do |row, y|
      x = row.index("I")
      @in = [x, y] if x
    end
  end

  def north(x, y)
    [x, y-1]
  end

  def west(x, y)
    [x-1, y]
  end

  def east(x, y)
    [x+1, y]
  end

  def south(x, y)
    [x, y+1]
  end

  def can_move_to?(x, y)
    y >= 0 && y < nb_rows &&
    x >= 0 && x < nb_columns &&
    square(x, y) != "#"
  end

  def square(x, y)
    @rows[y][x]
  end

  def nb_rows
    @rows.length
  end

  def nb_columns
    @rows.first.length
  end

  def moves
    {
      :east  => "E",
      :west  => "W",
      :north => "N",
      :south => "S"
    }
  end

  def solve
    current = { @in => "" }
    visited = {}

    @data.length.times do
      after = {}

      current.each do |pos, sequence|
        moves.each do |sym, letter|
          x, y = send(sym, *pos)
          next if visited.keys.include? [x,y]
          if can_move_to?(x, y)
            if square(x, y) == "O"
              @solution = sequence + letter
              return
            else
              after[ [x,y] ] = sequence + letter
            end
          end
        end
      end

      current = after
    end

    @solution = "I"
  end
end
