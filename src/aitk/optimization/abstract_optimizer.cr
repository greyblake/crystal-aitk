module Aitk
  abstract class AbstractOptimizer
    abstract def iterate
    abstract def solution
    abstract def score

    getter :iterations

    def initialize(type, @size, &@fitness_function : Array(Float64) -> Float64)
      @is_max =
        case type
        when :max then true
        when :min then false
        else raise ArgumentError.new("Type of optimizer must be :max or :min, but given #{type.inspect}")
        end
      @iterations = 0
    end

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

    private def calculate_score(solution : Array(Float64)) : Float64
      @fitness_function.call(solution)
    end

    private def better?(score1 : Float64, score2 : Float64) : Bool
      if @is_max
        score1 > score2
      else
        score1 < score2
      end
    end
  end
end
