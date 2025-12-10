require 'ap'
require 'matrix'
require 'algorithms'

class Machine < Data.define(:goal, :buttons, :joltages)
  def inspect
    "\#<Machine goal=#{sprintf("%#.4x", goal)} buttons=[#{buttons.map { sprintf("%#.4x", _1) }.join(", ")}] joltages=#{joltages}>"
  end

  def pretty_print(pp)
    pp.object_group(self) do
      pp.breakable
      pp.text "goal=#{sprintf("%#.4x", goal)}"
      pp.comma_breakable
      pp.text "buttons=[#{buttons.map { sprintf("%#.4x", _1 ) }.join(", ")}]"
      pp.comma_breakable
      pp.text "joltages=#{joltages}"
    end
  end

  def to_s
    inspect
  end
end

def parse(input)
  input.lines.map do |line|
    # p line
    goal_s = line.match(/\[([.#]+)\]/)[1]
    buttons = line.scan(/\((.+?)\)/).map do |button|
      button[0].split(",").map(&:to_i).map { 1 << _1 }.sum
    end
    joltages = line.match(/\{(.+?)\}/)[1].split(",").map(&:to_i)
    goal = goal_s.each_char.each_with_index.map do |c, i|
      c == "#" ? 1<<i : 0
    end.sum
    Machine.new(goal:, buttons:, joltages:)
  end
end

def solve_one(state, goal, buttons, path, max_depth)
  return path if state == goal
  return nil if path.length >= max_depth
  useful_buttons = buttons.filter { |b| (state ^ goal) & b != 0 }
  useful_buttons.each do |b|
    res = solve_one(state ^ b, goal, buttons, path + [b], max_depth)
    return res if res
  end
  nil
end

def part_one(input)
  total = 0
  machines = parse(input)
  machines.each do |m|
    res = nil
    (1..).each do |depth|
      res = solve_one(0, m.goal, m.buttons, [], depth)
      break if res
    end
    #p res
    total += res.length
  end
  
  total
end

Machine2 = Data.define(:buttons, :joltages)

def parse_two(input)
  input.lines.map do |line|
    joltages = Vector[*line.match(/\{(.+?)\}/)[1].split(",").map(&:to_i)]
    buttons = line.scan(/\((.+?)\)/).map do |button|
      idxs = button[0].split(",").map(&:to_i)
      v = Vector.zero(joltages.size)
      idxs.each do |i|
        v[i] = 1
      end
      v
    end
    buttons = Matrix[*buttons]
    Machine2.new(buttons:, joltages:)
  end
end

def solve_two(goal, buttons)
  max_presses = buttons.row_vectors.map do |b|
    goal.zip(b).map { |x,y| x * y }.filter { _1 > 0 }.min
  end
  p [goal, max_presses]
  0
end

def part_two(input)
  total = 0
  machines = parse_two(input)
  [pp(machines[0])].each do |m|
    res = solve_two(m.joltages, m.buttons)
    # ??
    p res
    total += res
  end
  total
end

input = ARGF.read
puts "===== Part 1 ====="
puts "\nResult: #{part_one(input)}"
puts "\n\n"
puts "===== Part 2 ====="
puts "\nResult: #{part_two(input)}"

