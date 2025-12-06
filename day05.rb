def parse(input)
  ranges, ingredients = input.split("\n\n")
  ranges = ranges.lines.map do |line|
    start, stop = line.chomp.split("-").map(&:to_i)
    start..stop
  end
  ingredients = ingredients.lines.map(&:to_i)
  return ranges, ingredients
end

def part_one(input)
  res = 0
  ranges, ingredients = parse(input)
  ingredients.map do |ing|
    ranges.any? { _1.include?(ing) }
  end.filter { _1 }.count
end

def part_two(input)
  res = 0
  ranges, _ = parse(input)
  loop do
    ranges.each_index do |i|
      next if ranges[i].nil?
      (i+1...ranges.length).each do |j|
        next if ranges[j].nil?
        if ranges[i].overlap?(ranges[j])
          start = [ranges[i].first, ranges[j].first].min
          stop = [ranges[i].last, ranges[j].last].max
          ranges[i] = start..stop
          ranges[j] = nil
        end
      end
    end
    if ranges.count { _1.nil? } > 0
      ranges = ranges.compact
    else
      break
    end
  end
  
  ranges.map(&:count).sum
end

input = ARGF.read
puts "===== Part 1 ====="
puts "\nResult: #{part_one(input)}"
puts "\n\n"
puts "===== Part 2 ====="
puts "\nResult: #{part_two(input)}"

