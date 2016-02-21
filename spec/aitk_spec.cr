require "./spec_helper"

describe Aitk do
  describe "#euclidean_distance" do
    context "vector length mismatch" do
      it "raises ArgumentError" do
        expect_raises(ArgumentError, "Vector mismatch") do
          Aitk.euclidean_distance([0], [1, 2])
        end
      end
    end

    context "vector size matches" do
      it "calculates distance" do
        Aitk.euclidean_distance([] of Float64, [] of Float64).should eq 0
        Aitk.euclidean_distance([0], [1]).should eq 1
        Aitk.euclidean_distance([-1, 2], [2, 6]).should eq 5
      end
    end
  end

  describe "#manhattan_distance" do
    it "calculates" do
      Aitk.manhattan_distance([] of Float64, [] of Float64).should eq 0
      Aitk.manhattan_distance([0], [5]).should eq 5
      Aitk.manhattan_distance([0, 2], [5, 4]).should eq 7
      Aitk.manhattan_distance([0, 2, 3], [5, 4, -1]).should eq 11
    end
  end

  describe "#chebyshev_distance" do
    it "returns the max distance in same dimension" do
      Aitk.chebyshev_distance([] of Float64, [] of Float64).should eq 0
      Aitk.chebyshev_distance([0], [5]).should eq 5
      Aitk.chebyshev_distance([0, 2], [5, 4]).should eq 5
      Aitk.chebyshev_distance([0, 2, -3], [5, 4, 6.5]).should eq 9.5
    end
  end
end
