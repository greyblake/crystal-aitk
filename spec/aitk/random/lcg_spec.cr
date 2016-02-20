require "../../spec_helper"

describe Aitk::Random::LCG do
  it "generates pseudo random numbers" do
    generator = Aitk::Random::LCG.new

    n = 100

    hash = {} of UInt64 => Int32
    n.times { |i| hash[i.to_u64] = 0 }

    10_000.times do
      num = (generator.next_int % n)
      hash[num] += 1
    end

    #30.times do
    #  puts generator.next_float
    #end
  end
end
