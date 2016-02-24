require "../../spec_helper"

describe Aitk::RBF::GaussianFunction do
  describe "for 2 inputs" do
    it "calculates gaussian function" do
      width = 1.0
      xcenter = 1.0
      ycenter = -2.0

      arr = [width, xcenter, ycenter]
      params = Slice(Float64).new(arr.to_unsafe, 3)
      func = Aitk::RBF::GaussianFunction.new(params)

      # test the peak
      func.call([1, -2.0]).should eq 1

      # test 1 step aside from the peak in all 4 directions
      func.call([2, -2.0]).should be_close(0.367, 0.01)
      func.call([0, -2.0]).should be_close(0.367, 0.01)
      func.call([1, -1.0]).should be_close(0.367, 0.01)
      func.call([1, -3.0]).should be_close(0.367, 0.01)

      # make sure, that width has an effect
      params[0] = width * 2
      func.call([2, -2.0]).should be_close(0.778801, 0.01)
    end
  end
end
