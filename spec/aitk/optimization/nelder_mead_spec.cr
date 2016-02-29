require "../../spec_helper"

describe Aitk::Optimization::NelderMead do
  it "finds optimal parameters for pyramid function" do
    pyramid_function = -> (params : Array(Float64)) do
      x = params[0]
      y = params[1]

      # Centers
      xc = 30.0
      yc = -15.0

      1 - ((x-xc) + (y-yc)).abs - ((y-yc) - (x-xc)).abs
    end

    optimization = Aitk::Optimization::NelderMead.new(2, pyramid_function)
    100.times { optimization.iterate }
    best_params = optimization.best_solution

    best_params[0].should be_close 30.0, 0.0001
    best_params[1].should be_close -15.0, 0.0001
  end
end
