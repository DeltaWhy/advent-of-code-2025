require 'ap'
require 'matrix'
require 'open3'

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
    Machine2.new(buttons:, joltages:)
  end
end

def part_two(input)
  machines = parse_two(input)
  machines.map do |m|
    smt = ""
    m.buttons.each_index do |i|
      smt += "(declare-const a#{i} Int)\n"
      smt += "(assert (>= a#{i} 0))\n"
    end
    smt += "(minimize (+ #{m.buttons.each_index.map { |i| "a#{i}" }.join(" ")}))\n"
    m.joltages.each_with_index do |v, i|
      idxs = m.buttons.each_with_index.filter { |b, _| b[i] > 0 }.map { |b, j| "a#{j}" }
      smt += "(assert (= #{v} (+ #{idxs.join(" ")})))\n"
    end
    smt += "(check-sat)\n(get-objectives)\n"
    # puts smt

    res = Open3.popen3("z3 -smt2 -in") do |stdin, stdout, stderr, wait_thr|
      stdin.puts smt
      stdin.close
      stdout.read
    end
    res

    raise if !res.start_with?("sat\n")
    
    res.match(/(\d+)\)\n\)\n/)[1].to_i
  end.sum
end

input = ARGF.read
puts "===== Part 1 ====="
puts "\nResult: #{part_one(input)}"
puts "\n\n"
puts "===== Part 2 ====="
puts "\nResult: #{part_two(input)}"

