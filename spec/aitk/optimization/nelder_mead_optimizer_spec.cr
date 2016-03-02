require "../../spec_helper"

describe Aitk::NelderMeadOptimizer do
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
    optimizer = Aitk::NelderMeadOptimizer.new(:max, 2) { |prm| pyramid.call(prm[0], prm[1]) }
    solution = optimizer.optimize(iterations: 100)
    solution[0].should be_close 30, 1
    solution[1].should be_close -15, 1
  end

  it "can optimize for minimum" do
    optimizer = Aitk::NelderMeadOptimizer.new(:min, 2) { |prm| upside_down.call(prm[0], prm[1]) }
    solution = optimizer.optimize(iterations: 100)
    solution[0].should be_close 30, 1
    solution[1].should be_close -15, 1
  end


  describe "#optimize" do
    context "with iterations parameter" do
      it "executes given number of iterations and returns best solution" do
        optimizer = Aitk::NelderMeadOptimizer.new(:max, 2) { |prm| pyramid.call(prm[0], prm[1]) }

        params = optimizer.optimize(iterations: 20)

        optimizer.iterations.should eq 20

        # In 20 iteration the result is about to be the same number
        params[0].should be_close 30.0, 1.0
        params[1].should be_close -15.0, 1.0

        # But it know 0.01 precise
        params[0].should_not be_close 30.0, 0.01
      end
    end

    context "with min_change" do
      it "stops optimization when in a given :period iterations change of score smaller than :min_change" do
        optimizer = Aitk::NelderMeadOptimizer.new(:max, 2) { |prm| pyramid.call(prm[0], prm[1]) }
        optimizer.optimize(period: 10, min_change: 0.01)
        (optimizer.score > 0.99).should eq true
        (optimizer.iterations % 10).should eq 0
      end
    end

    context "with block" do
      it "interrupts when block execution returns true" do
        optimizer = Aitk::NelderMeadOptimizer.new(:max, 2) { |prm| pyramid.call(prm[0], prm[1]) }
        optimizer.optimize { |optimizer| optimizer.score > 0.99 }
        (optimizer.score > 0.99).should eq true
        optimizer.iterations.should be_close 49, 5
      end

      it "when 'every' param is passed, callback is called every 'every' iterations" do
        optimizer = Aitk::NelderMeadOptimizer.new(:max, 2) { |prm| pyramid.call(prm[0], prm[1]) }

        count = 0
        optimizer.optimize(period: 10) do |optimizer|
          count += 1
          optimizer.iterations >= 60
        end
        count.should eq 6
      end
    end
  end
end

