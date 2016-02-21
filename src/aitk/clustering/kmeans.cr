module Aitk
  module Clustering
    class Cluster
      getter :vectors

      delegate size, vectors

      def initialize(centroid)
        @centroid = centroid.map &.to_f
        @vectors = [] of Array(Float64 | Int32)
      end

      def add(vector)
        @vectors << vector
      end

      def distance(vector)
        Aitk.euclidean_distance(vector, @centroid)
      end

      def recalculate_centroid
        @centroid.size.times do |i|
          sum = @vectors.reduce(0) { |sum, vec| sum += vec[i] }
          @centroid[i] = sum.to_f / @vectors.size
        end
      end
    end

    class KMeans
      getter :clusters

      def self.run(vectors, k)
        kmeans = new(vectors, k)
        kmeans.run
        kmeans
      end

      def initialize(@vectors, @k)
        centroids = @vectors.sample(@k)
        @clusters = Array(Cluster).new(@k) { |i| Cluster.new(centroids[i]) }
      end

      def run
        assign_vectors
        recalculate_centroids

        while reassign_vectors
          recalculate_centroids
        end
      end

      private def assign_vectors
        @vectors.each do |vec|
          cluster = find_nearest_cluster(vec)
          cluster.add(vec)
        end
      end

      private def reassign_vectors
        was_move = false
        @clusters.each do |cluster|
          cluster.vectors.each do |vector|
            nearest_cluster = find_nearest_cluster(vector)
            # Move vector to another cluster
            if nearest_cluster != cluster
              cluster.vectors.delete(vector)
              nearest_cluster.add(vector)
              was_move = true
            end
          end
        end
        was_move
      end

      private def find_nearest_cluster(vector)
        distances = @clusters.map { |cluster| cluster.distance(vector) }
        min_index = 0
        @k.times do |i|
          min_index = i if distances[i] < distances[min_index]
        end
        @clusters[min_index]
      end

      private def recalculate_centroids
        @clusters.each &.recalculate_centroid
      end
    end
  end
end

