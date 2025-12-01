dial = 50
res = 0
res2 = 0
readlines.each do |line|
  num = line.chomp.sub("R","").sub("L","-").to_i

  # part 2
  nxt = dial + num
  if nxt > 0
    res2 += nxt / 100
  elsif nxt == 0
    res2 += 1
  else
    res2 += (nxt / 100).abs
    # correction if landing exactly on negative multiple of 100
    res2 += 1 if nxt % 100 == 0
  end
  res2 -= 1 if dial == 0 and nxt < 0

  # part 1
  dial = (dial + num) % 100
  res += 1 if dial == 0
end
p res
p res2
