module Aitk
  module RBF
    class HillClimbingTrainer < BaseTrainer
      getter :step_sizes

      def initialize(@network, @training_set, acceleration, initial_velocity = 1.0)
        @memory = @network.memory

        # Step size per dimension
        @step_sizes = Array(Float64).new(@memory.size, initial_velocity)

        @step_candidates = [
          -1.0 * acceleration,
          -1.0 / acceleration,
          0.0,
          1.0 / acceleration,
          1.0 * acceleration
        ]
      end

      def train
        best_score = calc_score

        @memory.size.times do |i|
          best_step_candidate_index = -1

          # Find best step candidate
          original_val = @memory[i]
          @step_candidates.size.times do |j|
            @memory[i] = @memory[i] + (@step_sizes[i] * @step_candidates[j])
            temp_score = calc_score
            if temp_score < best_score
              best_score = temp_score
              best_step_candidate_index = j
            end
            @memory[i] = original_val
          end

          # Do actual move and adjust velocity (step_sizes)
          if best_step_candidate_index != -1
            @memory[i] = @memory[i] + (@step_sizes[i] * @step_candidates[best_step_candidate_index])
            @step_sizes[i] = @step_sizes[i] * @step_candidates[best_step_candidate_index]
          end
        end

        best_score
      end
    end
  end
end
