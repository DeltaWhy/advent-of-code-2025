def parse(input)
  input.lines.map(&:chomp)
end

def part_one(input)
  res = 0
  input = parse(input)
  input.each do |line|
    digit, pos = line.each_char.each_with_index.max_by { _1[0] }
    if pos == line.length - 1
      digit, pos = line[..-2].each_char.each_with_index.max_by { _1[0] }
    end
    digit2, pos2 = line[(pos+1)..].each_char.each_with_index.max_by { _1[0] }
    # p [digit, pos, digit2, pos2]
    res += digit.to_i * 10 + digit2.to_i
  end
  res
end

def part_two(input)
  res = 0
  input = parse(input)
  input.each do |line|
    left = 0
    right = line.length - 12
    joltage = ''
    begin
      str = line[left..right]
      digit, pos = str.each_char.each_with_index.max_by { _1[0] }
      joltage += digit
      # puts "left: #{left}\tright: #{right}\tline: #{line}\tstr: #{str}\tjoltage: #{joltage}"
      left = left + pos + 1
      right += 1
    end while right < line.length
    res += joltage.to_i
  end
  res
end

input = ARGF.read
puts "===== Part 1 ====="
puts "\nResult: #{part_one(input)}"
puts "\n\n"
puts "===== Part 2 ====="
puts "\nResult: #{part_two(input)}"

