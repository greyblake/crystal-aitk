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
  puts
end


def func(x, y)
  result = 0.0

  # 1st
  bx = 0.0  # center
  by = 0.0  # center
  result += 1 * Math::E ** (-((x-bx)**2 + (y-by)**2)  )

  # 2nd
  bx = -5.0  # center
  by = -5.0  # center
  result += 2 * Math::E ** (-((x-bx)**2 + (y-by)**2)  )

  # 3nd
  bx = 5.0  # center
  by = 5.0  # center
  result += 3 * Math::E ** (-((x-bx)**2 + (y-by)**2)  )

  # 4nd
  bx = 0.0  # center
  by = 5.0  # center
  result += 3 * Math::E ** (-((x-bx)**2 + (y-by)**2)  )

  # 5nd (the highest peak)
  bx = 1.0  # center
  by = 6.0  # center
  result += 4 * Math::E ** (-((x-bx)**2 + (y-by)**2)  )
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

draw(-8, 0.1, 8)
