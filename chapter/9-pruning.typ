// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *

= Pruning IEQ0 and IEQ1
We prune the Ideal Queries to remove terms which have no  or detrimental impact on the AP. This helps to reduce noise and focus only on terms that help the AP positively.

== Pruning IEQ0
We saw that while generating IEQ0, we have a `list_of_magnitudes` from where we pick a `tweak_magnitude` and tweak the weights of the terms in the query vector by:
```
new_weight = (1 + tweak_magnitude) * old_weight
```
If the `new_weight` for the term results in an increase in AP, we accept the tweak otherwise we revert it.

Earlier we had, `list_of_magnitudes` $= [4.0, 2.0, 1.0, 0.5]$. We modify this list to contain a $-1.0$ at the end so that our new `list_of_magnitudes` $=[4.0, 2.0, 1.0, 0.5, -1.0]$.

This has the effect that after normal IEQ0 generation, we tweak the weights of the terms by making them $0$ (essentially eliminating them), and seeing if the AP increases or remains same. If so, we eliminate the term.

*MAP achieved*: Since this process (by construction) can only improve the MAP, we achieve a slightly better MAP of *0.9060*, compared to IEQ0 which was 0.8919. Refer @table:map_of_ieqs.

Henceforth, this method will be referred to as *IEQ0Pruned*.

== Pruning IEQ1#sub("200")
Pruning IEQ1 is similar: We load the IEQ1 terms and weights and sort them by weight in decreasing order. Then, we go term by term and tweak the weight to 0. If this causes an increase in AP or the AP remains same, we accept the tweak, i.e. we eliminate the term, otherwise we retain it.

*MAP achieved*: Compared to IEQ1#sub("200"), which had a MAP of 0.8197, pruning helped the MAP significantly in this case, increasing it to *0.9055*. Refer @table:map_of_ieqs.

Henceforth, this method will be referred to as *IEQ1Pruned#sub("200")*.

== Pruning IEQ1#sub("1000")
Although very computationally expensive, we similarly prune IEQ1 queries containing 1000 terms.

*MAP achieved*: This method achieves an incredibly high MAP of *0.9760*. This is still very high compared to the MAP 
achieved by IEQ1#sub("1000") which was 0.9026. Refer @table:map_of_ieqs.

Henceforth, this method will be referred to as *IEQ1Pruned#sub("1000")*.

== Effect on sizes of the Ideal Expanded Queries (IEQs)
IEQ0 and IEQ1#sub("200") queries had a constant size of 200 terms.

Pruning had a significant effect on the sizes of many of the IEQs. 
Many of them became very short, some of them even containing only 10-20 terms while still giving very high AP. On the other hand, for some queries, only a small number of terms were pruned.

*Size of Pruned IEQs found to be highly correlated to the number of relevant documents*:\
Expectedly, the size of IEQ0Pruned and IEQ1Pruned#sub("200") queries were highly positively correlated to the number of relevant documents as we see in this plot:

#figure(
  image("../images/numrel_vs_numterms.png", width: 65%),
  caption: [No. of terms in query _vs._ No. of relevant documents]
)

This is expected, as an increase in the number of relevant documents typically introduces a greater diversity of terms. To retrieve all such documents effectively, the IEQ must incorporate more of these terms, leading to longer queries. In other words, the broader the set of relevant documents, the more terms are needed in the IEQ to maintain retrieval effectiveness.

A similar trend was seen for IEQ1Pruned#sub("1000"), although the number of terms in IEQ1Pruned#sub("1000") queries was generally much higher.

#figure(
  image("../images/numrel_vs_numterms1000.png", width: 65%),
  caption: [No. of terms in query _vs._ No. of relevant documents]
)

The *Spearman Correlation* (which measures the monotonic relationship between two ranked variables) between the number of relevant documents and the number of terms in IEQ for IEQ0Pruned, IEQ1Pruned#sub("200") and IEQ1Pruned#sub("1000") are: 0.8907, 0.8523 and 0.7951 respectively.

== Correlation Results
=== `l2_similarity`
#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1*][*IEQ0Pruned*][*IEQ1Pruned#sub("200")*][*IEQ1Pruned#sub("1000")*],
    [Pearson],[0.4858],[0.4697],[0.3451],[0.4082],[0.4163],
    [Kendall],[0.3762],[0.3607],[0.2743],[0.3121],[0.3283],
    [Spearman],[0.4765],[0.4521],[0.3480],[0.3931],[0.4114]
  ),
  caption: [Average Correlations for IEQ0, IEQ1, IEQ0Pruned#sub("200") and IEQ1Pruned#sub("1000") (using `l2_similarity`)]
)
=== `l1_similarity`
#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1*][*IEQ0Pruned*][*IEQ1Pruned#sub("200")*][*IEQ1Pruned#sub("1000")*],
    [Pearson],[-0.2100],[0.3472],[-0.1942],[0.2847],[0.3142],
    [Kendall],[-0.1643],[0.2594],[-0.1472],[0.2070],[0.2311],
    [Spearman],[-0.2079],[0.3351],[-0.1898],[0.2722],[0.3033]
  ),
  caption: [Average Correlations for IEQ0, IEQ1, IEQ0Pruned#sub("200") and IEQ1Pruned#sub("1000") (using `l1_similarity`)]
)
=== `jaccard_similarity`
#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1*][*IEQ0Pruned*][*IEQ1Pruned#sub("200")*][*IEQ1Pruned#sub("1000")*],
    [Pearson],[0.3285],[0.2550],[0.3239],[0.2591],[0.2732],
    [Kendall],[0.2526],[0.2119],[0.2424],[0.2015],[0.2180],
    [Spearman],[0.3334],[0.2831],[0.3226],[0.2667],[0.2960]
  ),
  caption: [Average Correlations for IEQ0, IEQ1, IEQ0Pruned#sub("200") and IEQ1Pruned#sub("1000") (using `jaccard_similarity`)]
)
=== `n2_similarity`
#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ1*][*IEQ0Pruned*][*IEQ1Pruned#sub("200")*][*IEQ1Pruned#sub("1000")*],
    [Pearson],[0.2746],[0.2897],[0.2941],[0.2606],[0.2660],
    [Kendall],[0.2280],[0.2238],[0.2346],[0.1989],[0.2045],
    [Spearman],[0.2975],[0.3000],[0.3078],[0.2622],[0.2733]
  ),
  caption: [Average Correlations for IEQ0, IEQ1, IEQ0Pruned#sub("200") and IEQ1Pruned#sub("1000") (using `n2_similarity`)]
)

*Conclusion*: As we see, this also did not result in an improve in terms of correlations. A possible reason could be that due to pruning, IEQs became too small and minimal due to which they had very small intersections with the EQs. This might have lead to unreliable correlations.

#pagebreak()
== MAP comparison of IEQs (final)
We finally present the MAPs achieved by all IEQ methods discussed so far:
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*IEQ*][*`num_expansion_terms`*][*MAP*],
    [Untweaked Oracle Rocchio], [200], [0.5121],
    [Untweaked Oracle Rocchio], [1000], [0.5465],
    [IEQ0], [200], [0.8919],
    [IEQ1#sub("1000")], [1000], [0.9026],
    [IEQ1#sub("200")], [200], [0.8197],
    [IEQ0Restricted], [200], [0.8256],
    [IEQ0Pruned], [11-172\*], [0.9060],
    [IEQ1Pruned#sub("200")], [16-177\*], [0.9055],
    [IEQ1Pruned#sub("1000")], [42-761\*], [*0.9760*]
  ),
  caption: [MAP of IEQs (Final)]
)<table:map_of_ieqs_final>
#text(size: 0.3cm)[\* Represented in the format `minimum_number_of_terms`-`maximum_number_of_terms`]
