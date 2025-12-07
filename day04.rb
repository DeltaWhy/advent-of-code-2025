require_relative "utils"
include Utils

def parse(input)
  grid = {}
  input.lines.each_with_index do |line, y|
    line = line.chomp
    line.each_char.each_with_index do |c, x|
      grid[Complex(x, y)] = true if c == "@"
    end
  end
  grid
end

def part_one(input)
  res = 0
  grid = parse(input)
  grid.each do |c, _|
    res += 1 if neighbors(c).map { grid[_1] }.compact.length < 4
  end

  res
end

def part_two(input)
  res = 0
  grid = parse(input)
  loop do
    reachable = []
    grid.each do |c, _|
      reachable << c if neighbors(c).map { grid[_1] }.compact.length < 4
    end
    res += reachable.length
    reachable.each do |c|
      grid.delete(c)
    end
    break if reachable.empty?
  end

  res
end

input = ARGF.read
puts "===== Part 1 ====="
puts "\nResult: #{part_one(input)}"
puts "\n\n"
puts "===== Part 2 ====="
puts "\nResult: #{part_two(input)}"
