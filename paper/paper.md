---
title: "January 6, 2021: A Social Network Perspective"
author: "Taggert W. Olson"
date: "Original: Spring 2025, Cal Poly Social Network Analysis. Lightly edited for clarity and accuracy, November 2026."
---

## 1. Purpose of the study

On January 6, 2021, thousands of Americans stormed the U.S. Capitol. The event is often described as unprecedented and as a product of online conspiracy and polarized media. That account implies geography should not matter: if the mobilizing space was entirely digital, participants could come from anywhere.

This study tests that assumption. It asks whether geographic availability, a well-documented driver of protest participation, still shaped who took part. The answer matters for social network research on why people join protests, and January 6 offers a new case for examining that mechanism.

## 2. Methodology

**Data.** I collected publicly available information on people charged in connection with January 6 from NPR's defendant database: each person's name, hometown, and charges. I scraped each page with ParseHub. A person was included if NPR listed their name and information. The database was updated as the Department of Justice filed new charges, so the sample reflects one point in time.

**Limitation of the sample.** Inclusion depends on being charged. Many people who took part but were never charged are missing, so the data describe defendants, not all participants.

**Network construction.** The final dataset contained 1,575 individuals, coded as nodes in R. Two people share an edge if their hometowns are within 50 miles of each other. The 50-mile threshold reflects the study's assumption: if two people living that close both chose to travel to Washington, D.C., their decisions may be connected through personal relationships, shared geographic availability, or another mechanism the network could reveal.

Edges therefore measure spatial proximity, not confirmed acquaintance or coordination. Of the 1,575 defendants, 1,523 have at least one neighbor within 50 miles; the other 52 are isolates.

## 3. Data analysis

The network visualization ([interactive version](https://tagwesley.github.io/#network)) shows how strongly geography shaped participation. In the western United States, defendants form small pockets and sub-networks disconnected from the rest. Moving east toward Washington, D.C., the clusters grow larger and more connected.

In the original map, darker points marked places where several defendants' locations overlapped. That darkness shows how many people came from one location; it is not itself a centrality measure. Centrality is reported separately below.

### Network-level measures

| Metric | Value |
| --- | --- |
| Density | 0.0143 |
| Number of components | 72 (73 when reproduced in 2026) |
| Largest component size | 724 |
| Average path length (largest component) | 12.11 |
| Diameter (largest component) | 37 |
| Global clustering coefficient | 0.797 |
| Average local clustering coefficient | 0.818 |

### Centrality

Defendants are shown by anonymous ID in this public version.

**Highest degree**

| ID | Degree | Betweenness | Eigenvector |
| --- | --- | --- | --- |
| P0279 | 84 | 24,010 | 1.000 |
| P0273 | 81 | 1,794 | 0.993 |
| P0238 | 81 | 4,580 | 0.894 |
| P0233 | 80 | 2,410 | 0.991 |
| P0246 | 77 | 955 | 0.969 |

**Highest betweenness**

| ID | Degree | Betweenness |
| --- | --- | --- |
| P1305 | 6 | 78,181 |
| P1076 | 38 | 62,915 |
| P0857 | 6 | 59,337 |
| P1479 | 2 | 58,973 |
| P1292 | 5 | 58,648 |

## 4. Analysis and conclusion

The network is sparse but highly clustered. Overall density is 0.0143: most defendants are not connected to most others. Locally, cohesion is strong, especially in the largest component of 724 people. The network splits into many disconnected components, so much of it consists of isolated or semi-isolated geographic groups rather than one connected national movement.

High clustering (global 0.797; average local 0.818) shows strong triadic closure: defendants tend to cluster with others nearby, forming tight geographic groups. An average path length of 12.11 and a diameter of 37 in the largest component indicate long chains rather than a compact national core.

Two kinds of central actor appear. The highest-degree defendants, such as P0279 (degree 84, eigenvector 1.0), sit inside the densest cluster, a geographic hub with many nearby defendants. The highest-betweenness defendants are different: several have only two to six ties but lie on the only paths between regional clusters. They are bridges between otherwise separate pockets. Because edges are geographic, this describes where these people live relative to others, not their influence or role on January 6.

Taken together, the network reflects localized, spatially bounded micro-movements more than one integrated national mobilization. This challenges digital-first interpretations of the insurrection.

**Limits and next steps.** A network built from distance will show some clustering by construction, so a fair test compares these results with a spatial baseline, such as defendants placed in proportion to population. A further extension could code each defendant's charges into a matrix and use QAP to test whether people who lived close together also faced similar charges. That would move the analysis closer to actual links between actors, beyond geographic proximity.

---

*Editing note (2026): corrected the event year in the opening (originally written as 2020), stated the isolate count, clarified that overlapping map points are not a centrality measure, and corrected the interpretation of betweenness, since the top bridging actors are low-degree nodes, not the highest-degree hubs. Findings and numbers are unchanged from the original submission.*
