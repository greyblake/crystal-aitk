module Aitk
  module RBF
    # Calculates gaussian function for N-dimension space.
    class GaussianFunction
      def initialize(@params : Slice(Float64))
      end

      def call(input)
        width = @params.first
        centers = @params + 1 # move pointer 1 element forward

        sqr_sum = 0
        centers.each_with_index do |x, index|
          sqr_sum += (x - input[index]) ** 2
        end

        Math::E ** (-(sqr_sum  / width ** 2))
      end
    end
  end
end
