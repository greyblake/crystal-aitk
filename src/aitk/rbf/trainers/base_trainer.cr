module Aitk
  module RBF
    abstract class BaseTrainer
      abstract def train

      def calc_score
        score = 0.0
        @training_set.each do |data|
          input, ideal_output = data
          output = @network.call(input)


          a, b = 1.0, 1.0
          ideal_output = [ideal_output[0], ideal_output[1]*a, ideal_output[2]*b]
          output = [output[0], output[1]*a, output[2]*b]

          score += Aitk.manhattan_distance(output, ideal_output)
        end
        score
      end
    end
  end
end
