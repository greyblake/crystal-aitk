module Aitk
  module Random
    # Linear congruential generator
    class LCG
      # Those numbers are take from wikipedia
      MODULUS = 4294967296_u64 # 2 ** 32
      INCREMENTER = 12345_u64
      MULTIPLIER = 1103515245_u64

      def initialize(@seed = Time.now.epoch)
      end

      def next_int : UInt64
        @seed = (MULTIPLIER * @seed + INCREMENTER) % MODULUS
      end

      def next_float : Float64
        next_int / MODULUS.to_f
      end
    end
  end
end
