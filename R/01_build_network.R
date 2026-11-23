# Expand the saved linked-location groups as cliques and complete bipartite ties.
dir.create("output", showWarnings = FALSE)
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
edge_table <- data.frame(from = lab[edges[,1]], to = lab[edges[,2]])
stopifnot(all(edges[,1] != edges[,2]), !anyDuplicated(data.frame(a=pmin(edges[,1],edges[,2]), b=pmax(edges[,1],edges[,2]))),
          nrow(edges) == 16528L, length(unique(as.vector(edges))) == 1521L)
write.csv(edge_table, "output/edge_list.csv", row.names = FALSE)
if (requireNamespace("igraph", quietly = TRUE)) {
  g <- igraph::graph_from_data_frame(edge_table, directed = FALSE)
  saveRDS(g, "output/network.rds")
}
