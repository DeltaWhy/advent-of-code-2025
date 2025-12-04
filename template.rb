def parse(input)
  input.lines.map(&:chomp)
end

def part_one(input)
  res = 0
  input = p parse(input)
  
  res
end

def part_two(input)
  res = 0
  input = p parse(input)
  
  res
end

input = ARGF.read
puts "===== Part 1 ====="
puts "\nResult: #{part_one(input)}"
puts "\n\n"
puts "===== Part 2 ====="
puts "\nResult: #{part_two(input)}"

