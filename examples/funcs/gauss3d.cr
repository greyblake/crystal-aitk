def scilab_plot(xs, ys, zs)
  puts "xs = #{xs.inspect}"
  puts "ys = #{ys.inspect}"

  puts "zs = []"
  zs.each do |arr|
    print "zs = [zs; "
    print arr.map(&.round(2)).join(",")
    puts "]"
  end

  puts "plot3d(xs, ys, zs)"
end


def func(x, y)
  a = 1 # max peak
  bx = 0.7  # center
  by = -0.7  # center
  c = 1  # width

  sum = a * Math::E ** (-((x-bx)**2 + (y-bx)**2)  / c**2)
end

def gen(from, step, to)
  out = [] of Float64
  ((to - from) / step).round.to_i.times do |i|
    out << (from + i * step)
  end
  out
end

def draw(from=-3.0, step=0.2, to=3.0)
  xs = gen(from, step, to)
  ys = gen(from, step, to)

  zs = Array(Array(Float64)).new

  xs.each do |x|
    arr = Array(Float64).new
    ys.each do |y|
      arr << func(x, y)
    end
    zs << arr
  end

  scilab_plot(xs, ys, zs)
end

draw(-2, 0.05, 2)
