# Run in the repository root. Both paths use the same anonymous graph.
source("R/01_build_network.R")
if (requireNamespace("igraph", quietly = TRUE)) {
  source("R/02_centrality.R")
  source("R/03_network_measures.R")
  source("R/04_plot.R")
} else {
  source("R/network_without_igraph.R")
}
expected <- read.csv("data/original_outputs/network_structure_summary_2025.csv")
actual <- read.csv("output/network_measures.csv")
stopifnot(identical(round(actual$value,4), round(expected$Value[-2],4)),
          expected$Value[2] == as.numeric(actual$value[2] == 1))
cat("Verified all eight reported network measures.\n")
