module Aitk
  module RBF
    class GreedyRandomTrainer < BaseTrainer
      def initialize(@network, @training_set, @scale = 100)
        @memory = @network.memory
      end

      def train
        best_score = calc_score
        @memory.size.times do |i|
          old_val = @memory[i]
          new_val = (rand - 0.5) * @scale
          @memory[i] = new_val
          new_score = calc_score

          # If the change does not bring improvement, put old value back
          if new_score > best_score
            @memory[i] = old_val
          end
        end
        best_score
      end
    end
  end
end
