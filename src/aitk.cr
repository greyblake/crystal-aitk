require "./aitk/**"

require "math"

module Aitk
  extend self

  def euclidean_distance(vec1 : Array, vec2 : Array)
    raise ArgumentError.new("Vector length mismatch") if vec1.size != vec2.size

    sum = 0.0
    vec1.size.times do |index|
      sum += (vec1[index] - vec2[index]) ** 2
    end
    Math.sqrt(sum)
  end

  def manhattan_distance(vec1 : Array, vec2 : Array)
    raise ArgumentError.new("Vector length mismatch") if vec1.size != vec2.size

    distance = 0.0
    vec1.size.times do |index|
      distance += (vec1[index] - vec2[index]).abs
    end
    distance
  end

  def chebyshev_distance(vec1 : Array, vec2 : Array)
    raise ArgumentError.new("Vector length mismatch") if vec1.size != vec2.size

    max_distance = 0.0
    vec1.size.times do |index|
      current_distance = (vec1[index] - vec2[index]).abs
      max_distance = current_distance if current_distance > max_distance
    end
    max_distance
  end
end
