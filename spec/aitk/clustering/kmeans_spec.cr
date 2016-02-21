require "../../spec_helper"

describe Aitk::Clustering::KMeans do
  it "finds clusters" do
    vectors = [
      [-10 , 8.0],  # cluster 1
      [-7.5, 6  ],  # cluster 1
      [0   , 2  ],  # cluster 2
      [-1  , -1 ],  # cluster 2
      [1   , 1  ]   # cluster 2
    ]

    kmeans = Aitk::Clustering::KMeans.run(vectors, k=2)
    clusters = kmeans.clusters
    clusters.size.should eq 2

    cluster1, cluster2 = clusters.sort_by &.size

    cluster1.vectors.size.should eq 2
    cluster1.vectors.includes?([-10, 8.0]).should eq true
    cluster1.vectors.includes?([-7.5, 6]).should eq true

    cluster2.vectors.size.should eq 3
    cluster2.vectors.includes?([0, 2]).should eq true
    cluster2.vectors.includes?([-1, -1]).should eq true
    cluster2.vectors.includes?([1, 1]).should eq true
  end
end
