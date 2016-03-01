module Aitk
  class GreedyRandomOptimizer < AbstractOptimizer
    getter :solution, :score

    def initialize(type, @size, @range = -1000.0..1000.0, &@fitness_function : Array(Float64) -> Float64)
      super(type, @size, &@fitness_function)
      @solution = Array(Float64).new(@size) { gen_random }
      @score = calculate_score(@solution)
    end

    def iterate
      @solution.each_with_index do |val, index|
        @solution[index] = gen_random
        new_score = calculate_score(@solution)
        if better?(new_score, @score)
          @score = new_score
        else
          # revert the change, if it does not improve the score
          @solution[index] = val
        end
      end

      @iterations += 1
    end

    private def gen_random
      span = @range.end - @range.begin
      rand * span + @range.begin
    end
  end
end
