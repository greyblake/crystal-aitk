require "../../src/aitk"
require "./gnuplot_helper"

include GnuplotHelper

k_max = 200.0
t_init = 10_000.0
t_final = 0.1


class PolynomialFunction
  def initialize(@c0, @c1, @c2)
  end

  def call(x)
    (@c2 * x**2) + (@c1 *x) + @c0
  end

  def coefficients
    [@c0, @c1, @c2]
  end
end

network = Aitk::RBF::Network.new(6, 9, 3)


def gen_training_set(size)
  training_set = Array({Array(Float64), Array(Float64)}).new(size)

  size.times do |i|
    x0 = (rand - 0.5) * 20
    x1 = (rand - 0.5) * 20
    x2 = (rand - 0.5) * 20
    output = [x0, x1, x2]

    func = PolynomialFunction.new(x0, x1, x2)
    input = Array(Float64).new(6)
    3.times do |i|
      input <<  i.to_f * 5
      input << func.call(i.to_f)
    end

    training_set << {input, output}
  end

  training_set
end


training_set = gen_training_set(100)
trainer = Aitk::RBF::SimulatedAnnealingTrainer.new(network, training_set)

10_000.times do |i|
  score = trainer.train

  puts "i=#{i};  score=#{score};   temperature=#{trainer.calculate_temperature}"
end

demo(network)


def demo(network)
  demo_with_coefficients(network, [5.0, -3.0, 5.0])
  demo_with_coefficients(network, [50.0, 4.0, 10.0])
  demo_with_coefficients(network, [2.0, 2.0, 2.0])
end

def demo_with_coefficients(network, cs)
  puts

  etalon_func = PolynomialFunction.new(cs[0], cs[1], cs[2])

  input = Array(Float64).new(6)
  3.times do |i|
    x = i.to_f * 3
    input << x
    input << etalon_func.call(x)
  end

  output = network.call(input)

  pp input
  pp cs
  pp output
  #pp network.memory

  network_func = PolynomialFunction.new(output[0], output[1], output[2])

  `rm ./tmp/data1.txt ./tmp/data2.txt`

  create_data_file("./tmp/data1.txt") do |x|
    etalon_func.call(x)
  end

  create_data_file("./tmp/data2.txt") do |x|
    network_func.call(x)
  end

  draw
  puts
end
