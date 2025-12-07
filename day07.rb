require 'set'

def parse(input)
  splitters = Set.new()
  start = nil
  input.lines.map(&:chomp).each_with_index do |line, y|
    line.each_char.each_with_index do |c, x|
      if c == "S"
        start = Complex(x, y)
      elsif c == "^"
        splitters << Complex(x, y)
      end
    end
  end
  return splitters, start
end

def part_one(input)
  @res = 0
  @splitters, start = parse(input)
  @max_y = @splitters.map { _1.imag }.max
  @visited = Set.new()
  def visit(c)
    @visited << c
    return if c.imag > @max_y
    while c.imag <= @max_y
      c += Complex(0, 1)
      if @splitters.include?(c)
        return if @visited.include?(c)
        @res += 1
        @visited << c
        visit(c + Complex(-1, 0))
        visit(c + Complex(1, 0))
        return
      end
    end
  end
  
  visit(start)
  @res
end

def part_two(input)
  @res = 0
  @splitters, @start = parse(input)
  @max_x = @splitters.map { _1.real }.max
  @max_y = @splitters.map { _1.imag }.max
  @reachable = {}

  def reachable(c)
    return @reachable[c] if @reachable.include?(c)
    res = 0
    (c.imag - 1).downto(0).each do |y|
      cur = Complex(c.real, y)
      left = cur - 1
      right = cur + 1
      break if @splitters.include?(cur)
      res += 1 if @start == cur
      res += reachable(left) if @splitters.include?(left)
      res += reachable(right) if @splitters.include?(right)
    end
    @reachable[c] = res
    res
  end

  (0..(@max_x + 1)).each do |x|
    @res += reachable(Complex(x, @max_y + 1))
  end

  @res
end

input = ARGF.read
puts "===== Part 1 ====="
puts "\nResult: #{part_one(input)}"
puts "\n\n"
puts "===== Part 2 ====="
puts "\nResult: #{part_two(input)}"

