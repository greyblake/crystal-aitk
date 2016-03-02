module Aitk
  class HillClimbingOptimizer < AbstractOptimizer
    getter :solution, :score

    def initialize(type, @size, acceleration = 0.1, initial_velocity = 1.0, &@fitness_function : Array(Float64) -> Float64)
      super(type, @size, &@fitness_function)

      # Step size per dimension
      @step_sizes = Array(Float64).new(@size, initial_velocity)

      @step_candidates = [
        -1.0 * acceleration,
        -1.0 / acceleration,
        0.0,
        1.0 / acceleration,
        1.0 * acceleration
      ]

      @solution = Array(Float64).new(@size) { rand }
      @score = calculate_score(@solution)
    end

    def iterate
      best_score = @score

      @size.times do |i|
        best_step_candidate_index = -1

        # Find best step candidate
        original_val = @solution[i]
        @step_candidates.size.times do |j|
          @solution[i] = @solution[i] + (@step_sizes[i] * @step_candidates[j])
          temp_score = calculate_score(@solution)
          if better?(temp_score, best_score)
            best_score = temp_score
            best_step_candidate_index = j
          end
          @solution[i] = original_val
        end

        # Do actual move and adjust velocity (step_sizes)
        if best_step_candidate_index != -1
          @solution[i] = @solution[i] + (@step_sizes[i] * @step_candidates[best_step_candidate_index])
          @step_sizes[i] = @step_sizes[i] * @step_candidates[best_step_candidate_index]
        end
      end

      @score = calculate_score(@solution)
      @iterations += 1
    end
  end
end
