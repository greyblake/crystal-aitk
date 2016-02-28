module Aitk
  module RBF
    class Network
      getter :memory

      def initialize(@input_size, @rbf_size, @output_size)
        input_weight_size = @input_size * @rbf_size
        output_weight_size = (@rbf_size + 1) * @output_size  # 1 stands for bias
        rbf_params_size = (@input_size + 1) * @rbf_size      # 1 stands for width of gauss function
        memory_size = input_weight_size + output_weight_size + rbf_params_size

        @memory = Array(Float64).new(memory_size) { (rand - 0.5) * 100 }
        ptr = @memory.to_unsafe

        rbf_params_index = input_weight_size
        output_weights_index = rbf_params_index + rbf_params_size

        @input_weights = Slice(Float64).new(ptr, input_weight_size)
        @rbf_params = Slice(Float64).new(ptr + rbf_params_index, rbf_params_size)
        @output_weights = Slice(Float64).new(ptr + output_weights_index, output_weight_size)

        # Initiate functions with parameters
        @rbfs = Array.new(@rbf_size) do |i|
          func_params_size = @input_size + 1
          func_params_ptr = ptr + rbf_params_index + i * func_params_size
          slice = Slice(Float64).new(func_params_ptr, func_params_size)
          GaussianFunction.new(slice)
        end
      end

      def call(input) : Array(Float64)
        if input.size != @input_size
          msg = "Input size mismatch. Input size is #{@input_size}, but received vector of #{input.size}"
          raise(ArgumentError.new(msg))
        end

        # Calculate weighted input
        weighted_input = Array(Float64).new(@input_size) do |i|
          input[i] * @input_weights[i]
        end

        # Calculate RBF output
        rbf_output = Array(Float64).new(@rbf_size + 1) { 0.0 }
        @rbf_size.times do |i|
          rbf_output[i] = @rbfs[i].call(weighted_input)
        end
        rbf_output[-1] = 1_f64 # bias

        # Calculate final output
        Array(Float64).new(@output_size) do |output_index|
          sum = 0.0
          rbf_output.each_with_index do |val, rbf_index|
            weight_index = output_index * (@rbfs.size + 1) + rbf_index
            sum += val * @output_weights[weight_index]
          end
          sum
        end
      end

      # Is used by SimulatedAnnealingTrainer
      # TODO: it mostly duplicates #initialize, refactor
      def set_memory(memory : Array(Float64))
        input_weight_size = @input_size * @rbf_size
        output_weight_size = (@rbf_size + 1) * @output_size  # 1 stands for bias
        rbf_params_size = (@input_size + 1) * @rbf_size      # 1 stands for width of gauss function
        memory_size = input_weight_size + output_weight_size + rbf_params_size

        @memory = memory
        ptr = @memory.to_unsafe

        rbf_params_index = input_weight_size
        output_weights_index = rbf_params_index + rbf_params_size

        @input_weights = Slice(Float64).new(ptr, input_weight_size)
        @rbf_params = Slice(Float64).new(ptr + rbf_params_index, rbf_params_size)
        @output_weights = Slice(Float64).new(ptr + output_weights_index, output_weight_size)

        # Initiate functions with parameters
        @rbfs = Array.new(@rbf_size) do |i|
          func_params_size = @input_size + 1
          func_params_ptr = ptr + rbf_params_index + i * func_params_size
          slice = Slice(Float64).new(func_params_ptr, func_params_size)
          GaussianFunction.new(slice)
        end
      end
    end
  end
end
