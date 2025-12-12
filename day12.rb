def parse(input)
  sections = input.split("\n\n")
  shapes = sections[0...-1]
  shapes.map! do |shape|
    shape.split("\n")[1..].map { |line| line.each_char.map { |c| c == "#" ? 1 : 0 } }
  end
  grids = sections[-1]
  grids = grids.chomp.split("\n").map do |line|
    size, presents = line.split(": ")
    size = size.split("x").map(&:to_i)
    presents = presents.split(" ").map(&:to_i)
    [size, presents]
  end
  [shapes, grids]
end

def part_one(input)
  res = 0
  shapes, grids = parse(input)
  cannot_fit = 0
  easy_fit = 0
  grids.each do |grid|
    size, presents = grid
    filled_cells = presents.each_with_index.map do |n, i|
      n * shapes[i].map(&:sum).sum
    end
    # p [size, size[0] * size[1], filled_cells, filled_cells.sum]
    if filled_cells.sum > (size[0] * size[1])
      # puts "\tCANNOT FIT"
      cannot_fit += 1
    end
    if (presents.sum.to_f / (size[0] / 3)).ceil <= (size[1] / 3)
      # puts "\tEASY FIT"
      easy_fit += 1
    end
  end
  puts "total grids: #{grids.length}\tcannot fit: #{cannot_fit}\neasy fit: #{easy_fit}\tremaining: #{grids.length - cannot_fit - easy_fit}"
  
  res
end

input = ARGF.read
puts "===== Part 1 ====="
puts "\nResult: #{part_one(input)}"

