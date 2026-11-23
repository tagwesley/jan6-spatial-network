# Plot the largest component, node size by degree.
suppressPackageStartupMessages(library(igraph))
g <- readRDS("output/network.rds")
comp  <- components(g)
giant <- induced_subgraph(g, which(comp$membership == which.max(comp$csize)))
set.seed(42)
png("output/largest_component.png", width = 1100, height = 860, res = 110)
par(mar = c(0, 0, 2, 0))
plot(giant, vertex.label = NA, vertex.size = 1 + sqrt(degree(giant)) / 2,
     vertex.color = adjustcolor("#1F3864", 0.6), vertex.frame.color = NA,
     edge.color = adjustcolor("grey50", 0.15), layout = layout_with_fr(giant),
     main = "Largest component (724 defendants), 50-mile proximity ties")
invisible(dev.off())
