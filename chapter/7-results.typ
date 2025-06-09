// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *

= Correlation results for IEQ0 and IEQ1
The average Pearson, Kendall and Spearman correlation coefficients across 250 queries are listed below for
each similarity type; for both IEQ0 and IEQ1 (with `num_expansion_terms`=1000).

== `l2_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1*],
    [Pearson],[0.4858],[0.4697],
    [Kendall],[0.3762],[0.3607],
    [Spearman],[0.4765],[0.4521]
  ),
  caption: [Average Correlations for IEQ0 and IEQ1 (using `l2_similarity`)]
)
== `l1_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1*],
    [Pearson],[-0.2100],[0.3472],
    [Kendall],[-0.1643],[0.2594],
    [Spearman],[-0.2079],[0.3351]
  ),
  caption: [Average Correlations for IEQ0 and IEQ1 (using `l1_similarity`)]
)
== `jaccard_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1*],
    [Pearson],[0.3285],[0.2550],
    [Kendall],[0.2526],[0.2119],
    [Spearman],[0.3334],[0.2831]
  ),
  caption: [Average Correlations for IEQ0 and IEQ1 (using `jaccard_similarity`)]
)
== `n2_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1*],
    [Pearson],[0.2746],[0.2897],
    [Kendall],[0.2280],[0.2238],
    [Spearman],[0.2975],[0.3000]
  ),
  caption: [Average Correlations for IEQ0 and IEQ1 (using `n2_similarity`)]
)

- We observe weak and weakly moderate correlations.
- Except for `l1_similarity`, correlations for both IEQ0 and IEQ1 are almost identical for all other similarities.
- It is unclear why correlations using `l1_similarity` are so different in IEQ0 and IEQ1.
