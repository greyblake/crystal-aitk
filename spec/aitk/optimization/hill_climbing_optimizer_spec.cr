require "../../spec_helper"

describe Aitk::HillClimbingOptimizer do
  # Pyramid function
  pyramid = -> (x : Float64, y : Float64) do
    xc = 20.0
    yc = -10.0
    1 - ((x-xc) + (y-yc)).abs - ((y-yc) - (x-xc)).abs
  end

  # Pyramid upside down
  upside_down = -> (x : Float64, y : Float64) do
    xc = 20.0
    yc = -10.0
    1 + ((x-xc) + (y-yc)).abs + ((y-yc) - (x-xc)).abs
  end

  it "can optimize for maximum" do
    optimizer = Aitk::HillClimbingOptimizer.new(:max, 2, acceleration: 0.01) { |prm| pyramid.call(prm[0], prm[1]) }
    solution = optimizer.optimize(iterations: 200)
    solution[0].should be_close 20, 0.1
    solution[1].should be_close -10, 0.1
  end

  it "can optimize for minimum" do
    optimizer = Aitk::HillClimbingOptimizer.new(:min, 2, acceleration: 0.01) { |prm| upside_down.call(prm[0], prm[1]) }
    solution = optimizer.optimize(iterations: 200)
    solution[0].should be_close 20, 0.1
    solution[1].should be_close -10, 0.1
  end
end
