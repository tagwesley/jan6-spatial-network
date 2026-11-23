# January 6 geographic proximity network

Taggert W. Olson · Cal Poly San Luis Obispo · 2025

The 2025 scrape of NPR’s January 6 defendant database contained 1,575 records. Of those, 1,570 had saved coordinates. Applying the original 80,467-metre cutoff to every geocoded pair reproduced the archived edge list exactly. Forty-nine geocoded records had no neighbor within the cutoff. The other 1,521 form the linked graph analyzed in the paper.

## Results for the linked graph

| Measure | Value |
| --- | ---: |
| Linked vertices | 1,521 |
| Undirected edges | 16,528 |
| Components | 72 |
| Largest component | 724 |
| Density | 0.0143 |
| Mean path length within largest component | 12.1139 |
| Diameter within largest component | 37 |
| Global clustering | 0.7972 |
| Mean local clustering | 0.8183 |

## Run the analysis

From the repository root, run `Rscript --vanilla run_all.R`. It expands the anonymized location groups, computes centrality and network measures, plots the largest component, and checks the eight values in the original 2025 summary. The program uses igraph when available. The offline alternative uses the Matrix package supplied with standard R installations. The output tables use anonymous IDs assigned within this reconstruction.

The graph describes spatial proximity among people charged in connection with January 6. Its distance rule contributes to its clustering. Establishing acquaintance or coordination would require independent evidence.

[Paper and original figures](paper/paper.md) · [Sample counts](data/sample_flow_2025.csv) · [Network measures](output/network_measures.csv)
