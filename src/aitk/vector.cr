module Aitk
  class Vector
    getter :array

    def initialize(@array : Array(Float64))
    end

    def +(vec)
      raise ArgumentError.new("Vector mismatch") if vec.size != size

      arr = @array.clone
      arr.size.times { |i| arr[i] += vec[i] }
      Vector.new(arr)
    end

    def -(vec)
      raise ArgumentError.new("Vector mismatch") if vec.size != size

      arr = @array.clone
      arr.size.times { |i| arr[i] -= vec[i] }
      Vector.new(arr)
    end

    def -
      arr = @array.clone
      arr.size.times { |i| arr[i] = -arr[i]}
      Vector.new(arr)
    end

    def *(mult)
      arr = @array.clone
      arr.size.times { |i| arr[i] *= mult }
      Vector.new(arr)
    end

    def /(div)
      arr = @array.clone
      arr.size.times { |i| arr[i] /= div }
      Vector.new(arr)
    end

    def size
      @array.size
    end

    def [](i)
      @array[i]
    end
  end
end
