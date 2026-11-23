# Offline alternative using base R and the recommended Matrix package.
# Breadth-first search gives unweighted distances and Brandes path dependencies.
e <- read.csv("output/edge_list.csv")
ids <- sort(unique(c(e$from, e$to)))
n <- length(ids)
i <- match(e$from,ids)
j <- match(e$to,ids)
nb <- split(c(j,i), factor(c(i,j), levels=seq_len(n)))
degree <- lengths(nb)
distance <- matrix(Inf,n,n)
between <- numeric(n)
for (s in seq_len(n)) {
  d <- rep.int(-1L,n)
  d[s] <- 0L
  sigma <- numeric(n)
  sigma[s] <- 1
  delta <- numeric(n)
  queue <- integer(n)
  queue[1] <- s
  first <- last <- 1L
  while(first <= last) {
    u <- queue[first]
    z <- nb[[u]]
    fresh <- z[d[z] < 0L]
    if(length(fresh)) {
      d[fresh] <- d[u] + 1L
      queue[last + seq_along(fresh)] <- fresh
      last <- last + length(fresh)
    }
    children <- z[d[z] == d[u]+1L]
    sigma[children] <- sigma[children]+sigma[u]
    first <- first+1L
  }
  reach <- queue[seq_len(last)]
  for(w in rev(reach[-1])) {
    z <- nb[[w]]
    parents <- z[d[z] == d[w]-1L]
    delta[parents] <- delta[parents] + sigma[parents] / sigma[w] * (1+delta[w])
  }
  delta[s] <- 0
  between <- between + delta/2
  distance[s,reach] <- d[reach]
}
component <- apply(is.finite(distance),1,which.max)
big <- which(component == as.integer(names(which.max(table(component)))))
dist_big <- distance[big,big]
A <- Matrix::sparseMatrix(i=c(i,j), j=c(j,i), x=1, dims=c(n,n))
# The identity shift prevents oscillation on bipartite components.
eigen_score <- rep(1,n)
for(step in seq_len(10000L)) {
  v <- as.numeric(A %*% eigen_score) + eigen_score
  v <- v/max(v)
  error <- max(abs(v-eigen_score))
  eigen_score <- v
  if(error < 1e-12) break
}
stopifnot(error < 1e-12)
row_dist <- distance
row_dist[!is.finite(row_dist)] <- 0
inv <- 1/distance
diag(inv) <- 0
centrality <- data.frame(id=ids,degree=unname(degree),betweenness=between,
                         closeness=1/rowSums(row_dist),harmonic=rowSums(inv),eigenvector=eigen_score)
write.csv(centrality[order(-degree),], "output/centrality.csv",row.names=FALSE)
closed <- as.numeric(Matrix::rowSums((A %*% A)*A))
triples <- degree*(degree-1)
value <- c(nrow(e)/choose(n,2),length(unique(component)),length(big),
           mean(dist_big[upper.tri(dist_big)]),max(dist_big),sum(closed)/sum(triples),
           mean((closed/triples)[triples>0]))
metrics <- c("Density","Number of components","Largest component size","Average path length (largest component)",
             "Diameter (largest component)","Global clustering coefficient","Average local clustering")
write.csv(data.frame(metric=metrics,value=round(value,4)),"output/network_measures.csv",row.names=FALSE)
# Distance-based layout of the largest component. No residential coordinates are required.
xy <- cmdscale(as.dist(dist_big), k=2)
links <- which(i %in% big)
aa <- match(i[links],big)
bb <- match(j[links],big)
png("output/largest_component.png",width=1100,height=860)
par(mar=c(1,1,3,1))
plot(xy,type="n",axes=FALSE,asp=1,xlab="",ylab="",main=paste("Largest proximity component:",length(big),"vertices"))
segments(xy[aa,1],xy[aa,2],xy[bb,1],xy[bb,2],col=adjustcolor("grey45",.15))
points(xy,pch=16,cex=.3+sqrt(degree[big])/12,col=adjustcolor("#1F3864",.65))
dev.off()
