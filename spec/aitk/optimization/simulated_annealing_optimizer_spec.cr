require "../../spec_helper"

describe Aitk::SimulatedAnnealingOptimizer do
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

  multiple_gauss = -> (x : Float64, y : Float64) do
    result = 0.0

    ## 1nd
    bx = 11.0  # center
    by = 11.0  # center
    result += 2 * Math::E ** (-((x-bx)**2 + (y-by)**2)  )

    ## 2nd
    bx = 5.0  # center
    by = 5.0  # center
    result += 2 * Math::E ** (-((x-bx)**2 + (y-by)**2)  )

    # 3nd (the highest peak)
    bx = 8.0  # center
    by = 8.0  # center
    result += 4 * Math::E ** (-((x-bx)**2 + (y-by)**2)  )
  end

  it "can optimize for maximum" do
    optimizer = Aitk::SimulatedAnnealingOptimizer.new(:max, 2, cycles: 10) { |prm| pyramid.call(prm[0], prm[1]) }
    solution = optimizer.optimize(iterations: 200)
    solution[0].should be_close 20, 0.1
    solution[1].should be_close -10, 0.1
  end

  it "can optimize for minimum" do
    optimizer = Aitk::SimulatedAnnealingOptimizer.new(:min, 2, cycles: 10) { |prm| upside_down.call(prm[0], prm[1]) }
    solution = optimizer.optimize(iterations: 200)
    solution[0].should be_close 20, 0.1
    solution[1].should be_close -10, 0.1
  end

  # Time consumer, takes about 200 milliseconds
  it "finds the maximum among local maximums" do
    optimizer = Aitk::SimulatedAnnealingOptimizer.new(:max, 2, cycles: 2000, temperature: 10..0.1) { |prm| multiple_gauss.call(prm[0], prm[1]) }
    solution = optimizer.optimize(iterations: 100)
    solution[0].should be_close 8.0, 0.1
    solution[1].should be_close 8.0, 0.1
  end
end
