require "../src/aitk"

network = Aitk::RBF::Network.new(1, 15, 1)

training_set = [
  {[-20.0], [400.0]},
  {[-15.0], [225.0]},
  {[-10.0], [100.0]},
  {[0.0], [0.0]},
  {[10.0], [100.0]},
  {[15.0], [225.0]},
  {[20.0], [400.0]},
]


random_trainer = Aitk::RBF::GreedyRandomTrainer.new(network, training_set, 200)
trainer = Aitk::RBF::HillClimbingTrainer.new(network, training_set, 2.5, 0.5)

1000.times do |i|
  #random_trainer.train
  score = trainer.train
  puts "i=#{i};  score=#{score}" if i % 1 == 0
end

pp network.call([0.0])
pp network.call([6.0])
pp network.call([40.0])


puts
pp network.memory
puts
pp trainer.step_sizes
puts



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

puts
draw(network, -60, 0.8, 60)
draw_training_set(training_set)
