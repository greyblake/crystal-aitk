def scilab_plot(xs, ys)
  puts "plot(#{xs.inspect}, #{ys.inspect})"
end


def func(x)
  b = 0  # center
  c = 1  # width

  Math::E ** (-(x-b)**2 / c**2)
end

def gen(from, step, to)
  out = [] of Float64
  ((to - from) / step).round.to_i.times do |i|
    out << (from + i * step)
  end
  out
end

def draw(from=-5.0, step=0.2, to=5.0)
  xs = gen(from, step, to)
  ys = xs.map { |x| func(x) }
  scilab_plot(xs, ys)
end


draw
