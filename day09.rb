def parse(input)
  input.lines.map do |line|
    Complex(*line.chomp.split(",").map(&:to_i))
  end
end

def part_one(input)
  res = 0
  coords = parse(input)
  coords.each_index do |i|
    (i + 1).upto(coords.length - 1) do |j|
      diff = coords[i] - coords[j]
      area = (diff.real.abs + 1) * (diff.imag.abs + 1)
      res = area if area > res
    end
  end
  
  res
end

def part_two(input)
  res = 0
  coords = parse(input)
  vertical_edges = (coords + [coords[0]]).each_cons(2).filter { _1.real == _2.real }.sort_by { _1[0].real }
  horizontal_edges = (coords + [coords[0]]).each_cons(2).filter { _1.imag == _2.imag }.sort_by { _1[0].imag }
  convex_points = coords.each_with_index.filter do |c, i|
    prev_point = coords[i - 1]
    next_point = (i + 1 == coords.length) ? coords[0] : coords[i + 1]
    if prev_point.real < c.real
      (next_point.imag > c.imag)
    elsif prev_point.real > c.real
      (next_point.imag < c.imag)
    elsif prev_point.imag < c.imag
      (next_point.real < c.real)
    elsif prev_point.imag > c.imag
      (next_point.real > c.real)
    else
      raise
    end
  end.map { _1[0] }.to_set
  best_rect = nil

  coords.each_index do |i|
    (i + 1).upto(coords.length - 1) do |j|
      x1, x2 = [coords[i].real, coords[j].real].minmax
      y1, y2 = [coords[i].imag, coords[j].imag].minmax
      area = (x2 - x1 + 1) * (y2 - y1 + 1)
      # puts "rect: #{coords[i]} #{coords[j]} area: #{area}"

      # if any red tiles are inside (not including edges) the rectangle, it can't be valid
      next if coords.any? do |c|
        c.real > x1 && c.real < x2 && c.imag > y1 && c.imag < y2
      end

      # if it's a 1-high rectangle, the interior can't contain any convex points
      next if y1 == y2 && convex_points.any? do |c|
        c.imag == y1 && c.real > x1 && c.real < x2
      end

      # same for 1-wide
      next if x1 == x2 && convex_points.any? do |c|
        c.real == x1 && c.imag > y1 && c.imag < y2
      end

      # check that no corner is outside (raycast right)
      corners = [Complex(x1, y1), Complex(x2, y1), Complex(x1, y2), Complex(x2, y2)]
      next if corners.any? do |c|
        next if coords.include?(c)
        next if horizontal_edges.any? do |p1, p2|
          p1.imag == c.imag && (p1.real < c.real && c.real < p2.real || p2.real < c.real && c.real < p1.real)
        end
        next if vertical_edges.any? do |p1, p2|
          p1.real == c.real && (p1.imag < c.imag && c.imag < p2.imag || p2.imag < c.imag && c.imag < p1.imag)
        end
        crossed_edges = vertical_edges.filter { _1[0].real > c.real }.count do |p1, p2|
          # puts "  point: #{c}  edge: #{p1} #{p2}"
          _y1, _y2 = [p1.imag, p2.imag].minmax
          c.imag >= _y1 && c.imag <= _y2
        end
        crossed_edges % 2 == 0
      end

      # check that no edges cross the rect
      next if horizontal_edges.any? do |p1, p2|
        _x1, _x2 = [p1.real, p2.real].minmax
        p1.imag > y1 && p1.imag < y2 && _x1 <= x1 && _x2 >= x2
      end
      next if vertical_edges.any? do |p1, p2|
        _y1, _y2 = [p1.imag, p2.imag].minmax
        p1.real > x1 && p1.real < x2 && _y1 <= y1 && _y2 >= y2
      end

      if area > res
        res = area
        best_rect = [Complex(x1, y1), Complex(x2, y2)]
      end
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

