# Node-level centrality: degree, betweenness, closeness, eigenvector.
suppressPackageStartupMessages(library(igraph))
g <- readRDS("output/network.rds")

cent <- data.frame(
  id          = V(g)$name,
  degree      = degree(g),
  betweenness = betweenness(g, directed = FALSE),
  closeness   = suppressWarnings(closeness(g)),   # igraph computes within components
  harmonic    = harmonic_centrality(g),           # better behaved on disconnected graphs
  eigenvector = eigen_centrality(g)$vector
)
cent <- cent[order(-cent$degree), ]
write.csv(cent, "output/centrality.csv", row.names = FALSE)

cat("Top 10 by degree:\n");      print(head(cent[, c("id","degree","eigenvector")], 10), row.names = FALSE)
cat("\nTop 10 by betweenness (bridges between clusters):\n")
print(head(cent[order(-cent$betweenness), c("id","degree","betweenness")], 10), row.names = FALSE)
