module Aitk
  module Optimization
    # Tries to find optimal parameters that result into maximum result of function.
    # Example:
    #   # Find x, y for the peak of the given gaussian function in 3D.
    #   def gaussian(input : Array(Float64))
    #     centers = [100.0, 3.0]
    #     width = 10.0
    #     sqr_sum = 0
    #     centers.each_with_index do |x, index|
    #       sqr_sum += (x - input[index]) ** 2
    #     end
    #     1 * Math::E ** (-(sqr_sum  / width ** 2))
    #   end
    #
    #   method = Aitk::Optimization::NelderMead.new(2, ->gaussian(Array(Float64)))
    #   1000.times { method.iterate }
    #   p method.best_solution # => [100.0, 3.0]
    #
    class NelderMead
      getter :scores, :solutions

      def initialize(@size, @score_function : Proc(Array(Float64), Float64))
        @solutions = Array(Vector).new(@size + 1) do
          random_array = Array(Float64).new(@size) { (rand - 0.5) * 100 }
          Vector.new(random_array)
        end

        @scores = @solutions.map { |solution| calc_score(solution) }
      end

      def iterate
        min_score, min_index = @scores.each_with_index.min

        # Find mean of all solution, except the worse one
        sum = Vector.new(@size)
        @solutions.each_with_index do |solution, index|
          sum += solution unless index == min_index
        end
        mean = sum / (@size)

        reflection = mean * 2  - @solutions[min_index]

        reflection_score = calc_score(reflection)

        if reflection_score > min_score
          expansion = reflection * 2 - mean
          @solutions[min_index] = expansion
        else
          contraction = (@solutions[min_index] + mean) / 2
          @solutions[min_index] = contraction
        end

        @scores[min_index] = calc_score(@solutions[min_index])
      end

      def best_solution
        best_score, best_index = @scores.each_with_index.max
        @solutions[best_index].array
      end

      def calc_score(solution) : Float64
        @score_function.call(solution.array)
      end
    end
  end
end
