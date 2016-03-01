module Aitk
  # Tries to find optimal parameters that result into maximum result of function.
  # If you want to understand better how it works check [this PDF](http://www.jasoncantarella.com/downloads/NelderMeadProof.pdf).
  #
  # Example: find a peak of the given pyaramid function.
  # ```
  # optimizer = Aitk::NelderMeadOptimizer.new(2) do |params|
  #   x,y = params
  #   xc, yc = 30.0, -15.0
  #   # pyramid function, with highest peak z=1, in x=30 and y=-15
  #   1 - ((x-xc) + (y-yc)).abs - ((y-yc) - (x-xc)).abs
  # end
  #
  # # Perform 100 iterations
  # optimizer.optimize(iterations: 100) # => [30.0, -15]
  #
  # # Interrupt optimization using the callback, that is being called every 10 iterations:
  # optimizer.optimize(period: 10) do |optimizer|
  #   # Stop, when best score is higher than 0.99
  #   optimizer.score > 0.99
  # end
  # # => [29.999, -15.0022]
  #
  # Interrupt, if 10 iterations, did not change score more than 0.01 :
  # optimizer.optimize(period: 10, min_change: 0.01) # => # [29.9999, -15.0002]
  # ```
  #
  # By default it tries to initialize solutions, that form simplex based a given range.
  # For size=2, it would look like the following triangle (points represent the solutions):
  #
  # ```
  # ^ y
  # |
  # * b
  # |
  # |
  # |
  # |
  # |
  # * - - - - - * - -> x
  # c           a
  #
  # a = [range.end, range.begin]
  # b = [range.begin, range.end]
  # c = [range.begin, range.begin]
  # ```
  class NelderMeadOptimizer
    getter :scores, :vectors, :iterations

    def initialize(@size, range = -100.0..100.0, &@fitness_function : Array(Float64) -> Float64)
      # Build initial simplex
      @vectors = Array(Vector).new(@size + 1) do |i|
        arr = Array(Float64).new(@size) { |j| i == j ? range.end : range.begin }
        Vector.new(arr)
      end

      @scores = @vectors.map { |vector| calc_score(vector) }
      @iterations = 0
    end

    # Iterates give number of times, trying to optimize the solution.
    def optimize(iterations = nil, period = 1, min_change = nil)
      raise ArgumentError.new("At least :iterations or :min_change must be specified") unless iterations || min_change
      optimize(iterations: iterations, period: period, min_change: min_change) { false }
    end

    def optimize(iterations = nil : Nil|Int, period = 1, min_change = nil : Nil|Number, &block) : Array(Float64)
      count = 0
      prev_score = score
      loop do
        iterate
        count += 1

        if iterations && count >= iterations
          break
        elsif count % period == 0
          break if min_change && (score - prev_score).abs < min_change
          break if yield(self)
          prev_score = score
        end
      end
      solution
    end

    # Get current best score.
    def score : Float64
      score_and_solution[0]
    end

    # Get current best solution.
    def solution : Array(Float64)
      score_and_solution[1]
    end

    def iterate
      min_score, min_index = @scores.each_with_index.min

      # Find mean of all solutions, except the worse one
      sum = Vector.new(@size)
      @vectors.each_with_index do |vector, index|
        sum += vector unless index == min_index
      end
      mean = sum / (@size)

      # Find reflection and its score
      reflection = mean * 2  - @vectors[min_index]
      reflection_score = calc_score(reflection)

      if reflection_score > min_score
        expansion = reflection * 2 - mean
        @vectors[min_index] = expansion
      else
        contraction = (@vectors[min_index] + mean) / 2
        @vectors[min_index] = contraction
      end

      @scores[min_index] = calc_score(@vectors[min_index])
      @iterations += 1
    end

    def score_and_solution
      best_score, best_index = @scores.each_with_index.max
      {best_score, @vectors[best_index].array}
    end

    private def calc_score(vector) : Float64
      @fitness_function.call(vector.array)
    end
  end
end
