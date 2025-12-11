def parse(input)
  nodes = input.lines.map { |line| line.split(":")[0] }
  edges = Hash.new { |h, k| h[k] = [] }
  input.lines.each do |line|
    source, sinks = line.split(": ")
    edges[source] += sinks.split(" ")
  end
  [nodes, edges]
end

def dfs(cur, goal, edges)
  return 1 if cur == goal
  edges[cur].map { |n| dfs(n, goal, edges) }.sum
end

def part_one(input)
  nodes, edges = parse(input)
  dfs("you", "out", edges)
end

def topo_sort(nodes, edges)
  new_edges = edges.map { |k, v| [k, v.clone] }.to_h
  res = []
  s = nodes.filter do |n|
    !new_edges.values.any? { |es| es.include?(n) }
  end
  until s.empty?
    cur = s.pop
    res << cur
    neighbors = new_edges.delete(cur)
    next if neighbors.nil?
    neighbors.each do |n|
      s.unshift(n) unless new_edges.values.any? { |es| es.include?(n) }
    end
  end
  raise "cycle found" unless new_edges.empty?
  res
end

def count_paths(start, goal, sorted_nodes, edges)
  paths = Hash.new(0)
  paths[start] = 1
  sorted_nodes.each do |cur|
    next if paths[cur] == 0
    edges[cur].each do |n|
      paths[n] += paths[cur]
    end
    # p [cur, paths]
    break if cur == goal
  end
  paths[goal]
end

def part_two(input)
  nodes, edges = parse(input)
  sorted_nodes = topo_sort(nodes, edges)
  edges_without_dac = edges.clone
  edges_without_dac.delete("dac")
  edges_without_fft = edges.clone
  edges_without_fft.delete("fft")
  svr_to_fft = count_paths("svr", "fft", sorted_nodes, edges_without_dac)
  svr_to_dac = count_paths("svr", "dac", sorted_nodes, edges_without_fft)
  fft_to_dac = count_paths("fft", "dac", sorted_nodes, edges)
  dac_to_fft = count_paths("dac", "fft", sorted_nodes, edges)
  fft_to_out = count_paths("fft", "out", sorted_nodes, edges_without_dac)
  dac_to_out = count_paths("dac", "out", sorted_nodes, edges_without_fft)

  svr_to_fft * fft_to_dac * dac_to_out + svr_to_dac * dac_to_fft * fft_to_out
end

input = ARGF.read
puts "===== Part 1 ====="
puts "\nResult: #{part_one(input)}"
puts "\n\n"
puts "===== Part 2 ====="
puts "\nResult: #{part_two(input)}"

