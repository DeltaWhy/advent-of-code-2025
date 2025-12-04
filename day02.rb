def parse(input)
  input.split(",").map(&:strip).map { |x| x.split("-").map { |x| x.to_i } }
end

def invalid?(num)
  s = num.to_s
  i = s.length / 2
  s[0...i] == s[i..]
end

def part_one(input)
  ranges = parse(input)
  res = 0
  ranges.each do |range|
    r = range[0]..range[1]
    r.filter { |x| invalid?(x) }.each do |x|
      res += x
    end
  end
  res
end

def invalid_two?(num)
  s = num.to_s
  (2..s.length).each do |n|
    if s.length % n == 0
      return true if s == s[0...(s.length/n)] * n
    end
  end
  false
end

def part_two(input)
  ranges = parse(input)
  res = 0
  ranges.each do |range|
    r = range[0]..range[1]
    r.filter { |x| invalid_two?(x) }.each do |x|
      res += p x
    end
  end
  res
end

input = ARGF.read
puts "===== Part 1 ====="
puts "\nResult: #{part_one(input)}"
puts "\n\n"
puts "===== Part 2 ====="
puts "\nResult: #{part_two(input)}"

