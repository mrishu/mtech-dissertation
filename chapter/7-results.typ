// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *

= Experimental Results

== Dataset Used <dataset>
The *Robust 2004* dataset is a benchmark collection which consists of a large set of news articles and government documents designed to evaluate the robustness of information retrieval models.

The dataset includes:
+ 250 topics (queries and their descriptions),
+ a corpus of 528,155 documents,
+ relevance information for 249 of the queries (in a `qrel` file).

#quote()[
The TREC Robust retrieval task focuses on _improving the consistency of retrieval technology by focusing on poorly performing topics._
]

#remark(title: "Dataset Link")[
https://ir-datasets.com/trec-robust04.html]

== MAP comparison of IEQs
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*IEQ*][*`num_expansion_terms`*][*MAP*],
    [Untweaked Oracle Rocchio], [200], [0.5121],
    [Untweaked Oracle Rocchio], [1000], [0.5465],
    [IEQ0], [200], [0.8919],
    [IEQ1], [1000], [0.9026],
    [IEQ1], [200], [0.8197]
  ),
  caption: [MAP of IEQs]
)<table:map_of_ieqs>
We see both IEQ0 and IEQ1 achieve very high MAPs.

In the figure below, we have plotted AP achieved on individual queries _vs._ $ln$(No. of relevant documents for the query) for both IEQ0 and IEQ1#sub("1000").
#figure(
  image("../images/numrel_vs_ap.png", width: 70%),
  caption: [AP _vs._ $ln$(No. of relevant documents) for IEQs]
)
The main observation is that in both cases, *IEQ performs worse as the number of relevant documents increases.*

== Correlation Results
The average Pearson, Kendall and Spearman correlation coefficients across all queries are listed below for
each similarity type; for both IEQ0 and IEQ1#sub("1000") ideal queries.

=== `l2_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1#sub("1000")*],
    [Pearson],[*0.4858*],[0.4697],
    [Kendall],[0.3762],[0.3607],
    [Spearman],[0.4765],[0.4521]
  ),
  caption: [Average Correlations for IEQ0 and IEQ1#sub("1000") (using `l2_similarity`)]
)
=== `l1_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1#sub("1000")*],
    [Pearson],[-0.2100],[0.3472],
    [Kendall],[-0.1643],[0.2594],
    [Spearman],[-0.2079],[0.3351]
  ),
  caption: [Average Correlations for IEQ0 and IEQ1#sub("1000") (using `l1_similarity`)]
)
=== `jaccard_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1#sub("1000")*],
    [Pearson],[0.3285],[0.2550],
    [Kendall],[0.2526],[0.2119],
    [Spearman],[0.3334],[0.2831]
  ),
  caption: [Average Correlations for IEQ0 and IEQ1#sub("1000") (using `jaccard_similarity`)]
)
=== `n2_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1#sub("1000")*],
    [Pearson],[0.2746],[0.2897],
    [Kendall],[0.2280],[0.2238],
    [Spearman],[0.2975],[0.3000]
  ),
  caption: [Average Correlations for IEQ0 and IEQ1#sub("1000") (using `n2_similarity`)]
)

- We observe moderate and weakly moderate correlations. For `l2_similarity`, we observe the highest correlation coefficients, among which the highest is the Pearson correlation coefficient for IEQ0, which is 0.4858.
- Except for `l1_similarity`, correlations for both IEQ0 and IEQ1#sub("1000") are almost identical for all other similarities.
- It is unclear why correlations using `l1_similarity` are so different in IEQ0 and IEQ1#sub("1000").
