def parse(input)
  input.lines.map(&:chomp).map(&:split).transpose.map do |a|
    a.map do |x|
      x =~ /^[0-9]/ ? x.to_i : x
    end
  end
end

def part_one(input)
  input = parse(input)
  (input.map do |line|
    if line[-1] == "+"
      line[0...-1].sum
    elsif line[-1] == "*"
      line[0...-1].reduce(&:*)
    else
      raise
    end
  end).sum
end

def parse2(input)
  rows = input.lines.map(&:chomp)
  col_idx = rows[-1].each_char.each_with_index.map { |x, i| x == " " ? nil : i }.compact
  problems = []
  col_idx.reverse.each do |idx|
    problem = rows.map { _1[idx..] }
    problems << problem
    rows.map! { _1[0...idx] }
  end
  problems
end

def part_two(input)
  res = 0
  problems = parse2(input)
  problems.each do |problem|
    op = problem[-1][0]
    nums = problem[0...-1]
    start = nums[0].length - 1
    nums2 = start.downto(0).map do |idx|
      nums.map { _1[idx] }.join
    end
    nums3 = nums2.filter { _1 =~ /\d/ }.map { _1.strip.to_i }
    if op == "+"
      res += nums3.sum
    elsif op == "*"
      res += nums3.reduce(&:*)
    else
      raise
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

