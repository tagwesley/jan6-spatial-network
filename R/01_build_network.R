# Build the 50-mile spatial proximity network of January 6 defendants.
#
# Defendants who share a hometown have identical ties, so the network is stored
# compactly by location group (names replaced with anonymous IDs):
#   data/group_sizes.txt      number of defendants in each location group
#   data/group_adjacency.txt  "i:o1 o2 ..." means group i is within 50 miles of
#                             groups i+o1, i+o2, ... (each pair listed once)
# Defendants in the same group are all tied to each other; defendants in two
# adjacent groups are all tied to each other. This rebuilds the exact edge list.
suppressPackageStartupMessages(library(igraph))

sizes <- as.integer(readLines("data/group_sizes.txt")[-1])
adj   <- readLines("data/group_adjacency.txt")[-1]

ends  <- cumsum(sizes); starts <- ends - sizes + 1
ids   <- function(g) starts[g]:ends[g]

within <- do.call(rbind, lapply(seq_along(sizes), function(g)
  if (sizes[g] > 1) t(combn(ids(g), 2)) else NULL))
between <- do.call(rbind, lapply(adj, function(line) {
  parts <- strsplit(line, ":", fixed = TRUE)[[1]]
  if (length(parts) < 2 || parts[2] == "") return(NULL)
  g <- as.integer(parts[1]); nbrs <- g + as.integer(strsplit(parts[2], " ")[[1]])
  do.call(rbind, lapply(nbrs, function(h) as.matrix(expand.grid(ids(g), ids(h)))))
}))

edges <- rbind(within, unname(between))
lab   <- sprintf("P%04d", seq_len(sum(sizes)))
g <- graph_from_edgelist(cbind(lab[edges[, 1]], lab[edges[, 2]]), directed = FALSE)
g <- simplify(g)

# Data-quality checks
stopifnot(vcount(g) == sum(sizes), all(degree(g) > 0))
cat("Location groups:", length(sizes), "\n")
cat("Nodes with at least one edge:", vcount(g), "\n")
cat("Edges:", ecount(g), "\n")
cat("Note: the paper reports 1,575 defendants; the 52 with no neighbor within\n",
    "50 miles (isolates) are not in the edge data.\n")

write.csv(as_data_frame(g, "edges"), "output/edge_list.csv", row.names = FALSE)
saveRDS(g, "output/network.rds")
