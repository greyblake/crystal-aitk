require "../../src/aitk"

optimizer = Aitk::GreedyRandomOptimizer.new(:max, 2, range: -100..100) do |params|
  x,y = params
  xc, yc = 30.0, -15.0
  # pyramid function, with highest peak z=1, in x=30 and y=-15
  1 - (((x-xc) + (y-yc)).abs + ((y-yc) - (x-xc)).abs)
end

pp optimizer.optimize(iterations: 500_000)
pp optimizer.score
pp optimizer.iterations
