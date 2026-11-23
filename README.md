# January 6 Defendants: A Spatial Proximity Network

R analysis of 1,575 January 6, 2021 defendants, asking whether geographic availability shaped who took part.

**[Explore the network interactively →](https://tagwesley.github.io/#network)**

## Paper

Read the write-up: [paper/paper.md](paper/paper.md).

## Question

The insurrection is often described as a purely online mobilization. If that were true, participants' home locations should be scattered. If geography still mattered, as it does in most protest movements, participants should cluster.

## Data and method

- **Source:** NPR's public database of people charged in connection with January 6 (names, hometowns, charges), scraped with ParseHub in spring 2025.
- **Network:** each defendant is a node. Two defendants share an edge if their hometowns are within 50 miles of each other.
- **Analysis:** igraph in R, using degree, betweenness, closeness, harmonic and eigenvector centrality, components, path length and clustering.
- **Privacy:** names are replaced with anonymous IDs (`P0001`, …).
- **Storage:** defendants from the same town have identical ties, so the network is stored compactly by location group in `data/group_sizes.txt` and `data/group_adjacency.txt`; `R/01_build_network.R` rebuilds the exact 16,529-edge list.

## Results

| Measure | Value |
| --- | --- |
| Nodes with ≥1 tie | 1,523 |
| Edges | 16,529 |
| Density | 0.0143 |
| Components | 73 |
| Largest component | 724 |
| Avg. path length (largest component) | 12.11 |
| Diameter (largest component) | 37 |
| Global clustering | 0.797 |

The network is sparse but tightly clustered. Participation came from many local, geographically bounded pockets rather than one connected national network. A few low-degree nodes have very high betweenness: they are the only links between regional clusters.

## Reproduce

```bash
Rscript run_all.R
```

Requires R with `igraph`. Writes the edge list, centrality table, network measures and a plot of the largest component to `output/`.

## Provenance and limitations

- The original 2025 class script was not recovered. These scripts were **rebuilt in November 2026 (with AI-assisted coding) from the paper's stated method**. They reproduce the paper's reported density, largest component, path length, diameter, clustering and centrality values exactly. Component count differs by one (73 here vs. 72 reported).
- The edge list contains only people with at least one neighbor within 50 miles, so 52 isolated defendants from the 1,575 are absent.
- Edges measure spatial proximity, not acquaintance or coordination. Because the graph is built from distance, high clustering is partly built in. A spatial null model is the planned next step.
- Defendants are a selected population (people charged), not all attendees.

## Author

Taggert W. Olson, Cal Poly San Luis Obispo, Political Science
