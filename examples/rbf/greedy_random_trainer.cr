require "../../src/aitk"
require "./gnuplot_helper"

include GnuplotHelper

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

network = Aitk::RBF::Network.new(6, 3, 3)


def gen_training_set(size)
  training_set = Array({Array(Float64), Array(Float64)}).new(size)

  size.times do |i|
    x0 = (rand - 0.5) * 100
    x1 = (rand - 0.5) * 100
    x2 = (rand - 0.5) * 100
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


trainers = (0..1000).to_a.map do |i|
  training_set = gen_training_set(10)
    Aitk::RBF::GreedyRandomTrainer.new(network, training_set, 200)
  #if i % 2 == 0
  #else
    #Aitk::RBF::HillClimbingTrainer.new(network, training_set, 20.5, 50.0)
  #end
end


scores = Array(Float64).new(5) { 2**16 }


prev_score = 2**16

10_000.times do |i|
  trainer_index = i % 100

  score = trainers[trainer_index].train
  4.times do
    score = trainers[trainer_index].train
  end

  puts "i=#{i};  score=#{score}" if i % 100 == 0

  # Stop training if there are no improvements during 5 iterations
  if i % 5 == 0
    if prev_score == score
      break
    else
      prev_score = score
    end
  end

  if i % 1000 == 0
    demo(network)
  end
end




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
  pp network.memory

  network_func = PolynomialFunction.new(output[0], output[1], output[2])

  `rm ./data1.txt ./data2.txt`

  create_data_file("./data1.txt") do |x|
    etalon_func.call(x)
  end

  create_data_file("./data2.txt") do |x|
    network_func.call(x)
  end

  draw
  puts
end
