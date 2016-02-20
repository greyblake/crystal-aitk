require "./spec_helper"

describe Aitk do
  describe "#euclidean_distance" do
    context "vector size mismatch" do
    end

    context "vector size matches" do
      it "calculates distance" do
        Aitk.euclidean_distance([0], [1]).should eq 1
      end
    end
  end
end
