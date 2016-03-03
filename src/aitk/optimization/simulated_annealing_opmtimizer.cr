module Aitk
  class SimulatedAnnealingOptimizer < AbstractOptimizer
    getter :solution

    def initialize(type, @size, temperature = 100.0..0.001, @cycles = 100, &@fitness_function : Array(Float64) -> Float64)
      super(type, @size, &@fitness_function)

      @t_init = temperature.begin.to_f
      @t_final = temperature.end.to_f

      if @t_init <= 0
        raise ArgumentError.new("Final temperature, must be at least a little greater than 0. Got #{@t_init}")
      end

      @solution = Array(Float64).new(@size) { rand }

      # Default number of iterations, if it's not specified in optimize method
      @max_iterations = 1000
    end

    def optimize(iterations = 1000)
      @max_iterations = iterations

      @max_iterations.times do |i|
        iterate
      end

      @solution
    end

    def iterate
      temperature = calculate_temperature
      current_score = calculate_score(@solution)
      current_score = calculate_score([1.0, 2.0])
      best_score = current_score
      best_solution = @solution.clone

      @cycles.times do
        old_solution = @solution.clone
        randomize_solution!(@solution, temperature)
        trial_score = calculate_score(@solution)

        if better?(trial_score, current_score)
          keep = true
        else
          keep = keep_worse?(current_score, trial_score, temperature)
        end

        if keep
          current_score = trial_score
          if better?(trial_score, best_score)
            best_score = trial_score
            best_solution = @solution.clone
          end
        else
          @solution = old_solution
        end
      end

      @iterations += 1

      # Set best solution and return its score
      @solution = best_solution
    end

    def score
      calculate_score(@solution)
    end

    private def calculate_temperature
      @t_init * ((@t_final / @t_init) ** (@iterations.to_f / @max_iterations))
    end

    private def randomize_solution!(solution, temperature)
      @size.times do |i|
        solution[i] += (rand - 0.5) * temperature
      end
    end

    # Should worse solution be accepted?
    # It assumes, that trial_score > current_score, otherwise result can be > 1
    private def keep_worse?(current_score, trial_score, temperature)
      probability = Math::E ** (-(trial_score - current_score)/temperature)
      result = rand < probability
      result
    end
  end
end
