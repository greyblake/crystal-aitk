module ScilabHelper
  def draw_training_set(set)
    xs = Array(Float64).new
    ys = Array(Float64).new
    set.each do |pair|
      xs << pair[0][0]
      ys << pair[1][0]
    end
    puts "plot(#{xs.inspect}, #{ys.inspect}, 'x')"
  end

  def scilab_plot(xs, ys)
    puts "plot(#{xs.inspect}, #{ys.inspect})"
  end


  def gen(from, step, to)
    out = [] of Float64
    ((to - from) / step).round.to_i.times do |i|
      out << (from + i * step)
    end
    out
  end

  def draw(network, from=-5.0, step=0.2, to=5.0)
    xs = gen(from, step, to)
    ys = xs.map { |x| network.call([x]).first }
    scilab_plot(xs, ys)
  end
end
