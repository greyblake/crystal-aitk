require "../spec_helper"

describe Aitk::Vector do
  describe "#[]" do
    it "allows to access items by index" do
      v = Aitk::Vector.new([1.0, 4.0])
      v[0].should eq 1.0
      v[1].should eq 4.0
    end
  end

  describe "#size" do
    it "returns size of vector" do
      v1 = Aitk::Vector.new([1.0])
      v1.size.should eq 1

      v2 = Aitk::Vector.new([1.0, 4.0])
      v2.size.should eq 2
    end
  end

  describe "#+" do
    it "adds vectors" do
      v1 = Aitk::Vector.new([1.0, 5.0])
      v2 = Aitk::Vector.new([3.0, -2.5])
      v = v1 + v2
      v.array.should eq [4.0, 2.5]
    end

    context "vectors have different size" do
      it "raises ArgumentError" do
        v1 = Aitk::Vector.new([1.0])
        v2 = Aitk::Vector.new([3.0, -2.5])
        expect_raises(ArgumentError, "Vector mismatch") do
          v1 + v2
        end
      end
    end
  end

  describe "#-" do
    it "substracts vectors" do
      v1 = Aitk::Vector.new([1.0, 5.0])
      v2 = Aitk::Vector.new([3.0, 3.0])
      v = v1 - v2
      v.array.should eq [-2.0, 2.0]
    end

    context "vectors have different size" do
      it "raises ArgumentError" do
        v1 = Aitk::Vector.new([1.0])
        v2 = Aitk::Vector.new([3.0, -2.5])
        expect_raises(ArgumentError, "Vector mismatch") do
          v1 - v2
        end
      end
    end

    context "without arguments" do
      it "negates itself" do
        v = Aitk::Vector.new([3.0, -2.5])
        new_v = -v
        new_v.array.should eq [-3.0, 2.5]
      end
    end
  end

  describe "#*" do
    it "multiplies vector" do
      v = Aitk::Vector.new([3.0, -2.5]) * 4
      v.array.should eq [12.0, -10.0]
    end
  end

  describe "#/" do
    it "divides vector" do
      v = Aitk::Vector.new([5.0, -2.5]) / 5
      v.array.should eq [1.0, -0.5]
    end
  end
end
