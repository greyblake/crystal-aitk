require "../../spec_helper"

describe Aitk::GreedyRandomOptimizer do
  # Pyramid function
  pyramid = -> (x : Float64, y : Float64) do
    xc = 30.0
    yc = -15.0
    1 - ((x-xc) + (y-yc)).abs - ((y-yc) - (x-xc)).abs
  end

  # Pyramid upside down
  upside_down = -> (x : Float64, y : Float64) do
    xc = 30.0
    yc = -15.0
    1 + ((x-xc) + (y-yc)).abs + ((y-yc) - (x-xc)).abs
  end

  it "can optimize for maximum" do
    optimizer = Aitk::GreedyRandomOptimizer.new(:max, 2, range: -50..50) { |prm| pyramid.call(prm[0], prm[1]) }
    solution = optimizer.optimize(iterations: 1000)
    solution[0].should be_close 30, 1
    solution[1].should be_close -15, 1
  end

  it "can optimize for minimum" do
    optimizer = Aitk::GreedyRandomOptimizer.new(:min, 2, range: -50..50) { |prm| upside_down.call(prm[0], prm[1]) }
    solution = optimizer.optimize(iterations: 1000)
    solution[0].should be_close 30, 1
    solution[1].should be_close -15, 1
  end
end
