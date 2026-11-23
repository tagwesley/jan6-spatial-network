# Whole-network measures, plus a check against the values reported in the paper.
suppressPackageStartupMessages(library(igraph))
g <- readRDS("output/network.rds")

comp  <- components(g)
giant <- induced_subgraph(g, which(comp$membership == which.max(comp$csize)))

m <- data.frame(
  metric = c("Density", "Number of components", "Largest component size",
             "Average path length (largest component)", "Diameter (largest component)",
             "Global clustering coefficient", "Average local clustering"),
  value  = c(edge_density(g), comp$no, max(comp$csize),
             mean_distance(giant), diameter(giant),
             transitivity(g, type = "global"),
             transitivity(g, type = "average"))
)
m$value <- round(m$value, 4)
write.csv(m, "output/network_measures.csv", row.names = FALSE)
print(m, row.names = FALSE)

# Reproducibility check against the 2025 paper
reported <- c(density = 0.0143, largest = 724, global_clustering = 0.7972)
ok <- c(round(edge_density(g), 4) == reported["density"],
        max(comp$csize) == reported["largest"],
        round(transitivity(g, "global"), 4) == reported["global_clustering"])
cat("\nMatches paper (density, largest component, global clustering):", ok, "\n")
