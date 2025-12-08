require 'matrix'
require 'ap'

def parse(input)
  input.lines.map do |line|
    Vector[*line.chomp.split(",").map(&:to_i)]
  end
end

def part_one(input)
  nodes = parse(input)
  edges = []
  nodes.each_index do |i|
    (i + 1).upto(nodes.length - 1).each do |j|
      edges << [[i, j], (nodes[i] - nodes[j]).magnitude]
    end
  end
  edges.sort_by! { _1[1] }
  groups = {}
  nodes.each_with_index { groups[_1] = _2 }
  
  count = 0
  edges.each do |pair, length|
    i, j = pair
    n1 = nodes[i]
    n2 = nodes[j]
    g1 = groups[n1]
    g2 = groups[n2]
    # p [pair, length]
    if g1 == g2
      # already merged
      # p "already merged"
    else
      # merge
      groups.each_key do |k|
        groups[k] = g1 if groups[k] == g2
      end
    end

    count += 1
    # ap groups
    break if count >= 1000  # use 10 for test input
  end

  groups_sizes = Hash.new(0)
  groups.each do |k, v|
    groups_sizes[v] += 1
  end
  # p groups_sizes
  groups_sizes.values.max(3).reduce(&:*)
end

def part_two(input)
  nodes = parse(input)
  edges = []
  nodes.each_index do |i|
    (i + 1).upto(nodes.length - 1).each do |j|
      edges << [[i, j], (nodes[i] - nodes[j]).magnitude]
    end
  end
  edges.sort_by! { _1[1] }
  groups = {}
  nodes.each_with_index { groups[_1] = _2 }
  
  last_edge = nil
  edges.each do |pair, length|
    i, j = pair
    n1 = nodes[i]
    n2 = nodes[j]
    g1 = groups[n1]
    g2 = groups[n2]
    # p [pair, length]
    if g1 == g2
      # already merged
      # p "already merged"
    else
      # merge
      groups.each_key do |k|
        groups[k] = g1 if groups[k] == g2
      end
      last_edge = pair
    end

    # ap groups
  end

  nodes[last_edge[0]][0] * nodes[last_edge[1]][0]
end

input = ARGF.read
puts "===== Part 1 ====="
puts "\nResult: #{part_one(input)}"
puts "\n\n"
puts "===== Part 2 ====="
puts "\nResult: #{part_two(input)}"

