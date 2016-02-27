module GnuplotHelper
  def gen(from, step, to)
    out = [] of Float64
    ((to - from) / step).round.to_i.times do |i|
      out << (from + i * step)
    end
    out
  end

  def create_data_file(filename, from=-10.0, step=0.2, to=10.0)
    File.open(filename, "w+") do |file|
      xs = gen(from, step, to)
      xs.each do |x|
        y = yield(x)
        file.puts("#{x} #{y}")
      end
    end
  end

  def draw
    `gnuplot < ./generate_plot.gnu && eog output.png`
  end
end
