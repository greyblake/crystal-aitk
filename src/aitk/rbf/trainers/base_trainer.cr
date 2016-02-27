module Aitk
  module RBF
    abstract class BaseTrainer
      abstract def train

      def calc_score
        score = 0.0
        @training_set.each do |data|
          input, ideal_output = data
          output = @network.call(input)
          score += Aitk.euclidean_distance(output, ideal_output)
        end
        score
      end
    end
  end
end
