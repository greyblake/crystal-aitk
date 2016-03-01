require "../../src/aitk"

optimizer = Aitk::NelderMeadOptimizer.new(2) do |params|
  x,y = params
  xc, yc = 30.0, -15.0
  # pyramid function, with highest peak z=1, in x=30 and y=-15
  1 - ((x-xc) + (y-yc)).abs - ((y-yc) - (x-xc)).abs
end


#pp optimizer.optimize(period: 10, min_change: 0.01)
pp optimizer.optimize(iterations: 20)
