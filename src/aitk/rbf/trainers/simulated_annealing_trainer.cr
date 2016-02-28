module Aitk
  module RBF
    class SimulatedAnnealingTrainer < BaseTrainer
      #DEFAULT_T_INIT = 20.0
      #DEFAULT_T_FINAL = 0.01
      #DEFAULT_ITERATIONS = 1000
      #DEFAULT_CYCLES = 1000

      def initialize(@network, @training_set)
        @t_init = 20.0
        @t_final = 0.001
        @k_max = 10_000
        @cycles = 10_000

        @k = 0
      end

      def train
        @k_max.times do |i|
          iterate_training
        end
      end

      def iterate_training
        @k += 1
        temperature = calculate_temperature
        current_score = calc_score
        best_score = calc_score
        best_memory = @network.memory.clone

        @cycles.times do
          old_memory = @network.memory.clone
          randomize_memory!(@network.memory, temperature)
          trial_score = calc_score

          if trial_score <= current_score
            keep = true
          else
            keep = keep_worse?(current_score, trial_score, temperature)
          end

          if keep
            current_score = trial_score
            if trial_score < best_score
              best_score = trial_score
              best_memory = @network.memory.clone
            end
          else
            @network.set_memory(old_memory)
          end
        end

        # Set best solution and return its score
        @network.set_memory(best_memory)
        best_score
      end

      def calculate_temperature
        @t_init * ((@t_final / @t_init) ** (@k.to_f / @k_max))
      end

      def randomize_memory!(memory, temperature)
        2.times do
          index = rand(memory.size)
          memory[index] += (rand - 0.5) * temperature
        end
      end

      # It assumes, that trial_score > current_score, otherwise result can be > 1
      def keep_worse?(current_score, trial_score, temperature)
        probability = Math::E ** (-(trial_score - current_score)/temperature)
        result = rand < probability
        result
      end
    end
  end
end
