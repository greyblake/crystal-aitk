require "../src/aitk"

SCILAB_SPECIFIERS = [".r", "xb", "*g", "xk", "xr"]

# Prints command that can be copied and pasted into scilab to visualize
def scilab_plot(vectors, ch = ".")
  xs = vectors.map { |v| v[0].round }
  ys = vectors.map { |v| v[1].round }
  puts "plot(#{xs.inspect}, #{ys.inspect}, #{ch.inspect})"
end

vectors = [
  [-1, -2.0],
  [2, 4.0],
  [4, 0.0],
  [140, 1],
  [142.0, 0.05],
]

800.times do
  k = (rand > 0.7) ? 2 : 1

  xsign = rand > 0.5 ? : -1 : 1
  ysign = rand > 0.5 ? : -1 : 1

  x = rand * 100 * k * xsign
  y = rand * 100 * k * ysign
  vectors << [x, y]
end


kmeans = Aitk::Clustering::KMeans.run(vectors, k=5)

puts
puts
kmeans.clusters.each_with_index do |cluster, index|
  specifier = SCILAB_SPECIFIERS[index]
  scilab_plot(cluster.vectors, specifier)
end
puts
puts
