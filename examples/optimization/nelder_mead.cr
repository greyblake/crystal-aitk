require "../../src/aitk"

# Example of using Nelder Mead method to find peak of gaussian function.
# Peak is located in the center, which is in current example x=100, y=-50.

def gaussian(input : Array(Float64))
  centers = [100.0, -50.0]
  width = 5.0

  sqr_sum = 0
  centers.each_with_index do |x, index|
    sqr_sum += (x - input[index]) ** 2
  end
  Math::E ** (-(sqr_sum  / width ** 2))
end

method = Aitk::Optimization::NelderMead.new(2, ->gaussian(Array(Float64)))

200.times do |i|
  method.iterate
end
pp method.best_solution
