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
  class NelderMeadOptimizer < AbstractOptimizer
    getter :scores, :vectors, :iterations

    def initialize(type, @size, range = -100.0..100.0, &@fitness_function : Array(Float64) -> Float64)
      super(type, @size, &@fitness_function)

      # Build initial simplex
      @vectors = Array(Vector).new(@size + 1) do |i|
        arr = Array(Float64).new(@size) { |j| i == j ? range.end : range.begin }
        Vector.new(arr)
      end

      @scores = @vectors.map { |vector| calc_score(vector) }
    end

    def iterate
      worse_score, worse_index = worse_score_and_index

      # Find mean of all solutions, except the worse one
      sum = Vector.new(@size)
      @vectors.each_with_index do |vector, index|
        sum += vector unless index == worse_index
      end
      mean = sum / (@size)

      # Find reflection and its score
      reflection = mean * 2  - @vectors[worse_index]
      reflection_score = calc_score(reflection)

      if better?(reflection_score, worse_score)
        expansion = reflection * 2 - mean
        @vectors[worse_index] = expansion
      else
        contraction = (@vectors[worse_index] + mean) / 2
        @vectors[worse_index] = contraction
      end

      @scores[worse_index] = calc_score(@vectors[worse_index])
      @iterations += 1
    end

    # Get current best solution.
    def solution : Array(Float64)
      best_solution_and_score[0]
    end

    # Get current best score.
    def score : Float64
      best_solution_and_score[1]
    end

    private def best_solution_and_score
      best_score, best_index =
        if @is_max
          @scores.each_with_index.max
        else
          @scores.each_with_index.min
        end
      {@vectors[best_index].array, best_score}
    end

    private def worse_score_and_index
      if @is_max
        @scores.each_with_index.min
      else
        @scores.each_with_index.max
      end
    end

    private def calc_score(vector) : Float64
      @fitness_function.call(vector.array)
    end
  end
end
