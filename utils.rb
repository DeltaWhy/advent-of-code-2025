module Utils
  DIRECTIONS = {
    nw: Complex(-1, -1),
    n: Complex(0, -1),
    ne: Complex(1, -1),
    w: Complex(-1, 0),
    e: Complex(1, 0),
    sw: Complex(-1, 1),
    s: Complex(0, 1),
    se: Complex(1, 1)
  }

  module_function

  def neighbors(c)
    DIRECTIONS.map { c + _2 }
  end
end
