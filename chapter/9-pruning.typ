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

Earlier we had, `list_of_magnitudes` $= [4.0, 2.0, 1.0, 0.5]$.\
We modify this list to contain a $-1.0$ at the end so that our\
new `list_of_magnitudes` $=[4.0, 2.0, 1.0, 0.5, -1.0]$.

This has the effect that after normal IEQ0 generation, we tweak the weights of the terms by making them $0$ (essentially eliminating them), and seeing if the AP increases.

Henceforth, this method will be referred to as *IEQ0Pruned*.

=== MAP achieved
Since, this process (by construction) can only improve the MAP, we achieve a slightly better MAP of *0.9060*, compared to IEQ0 which was 0.8919. Refer @table:map_of_ieqs.


== Pruning IEQ1
Pruning IEQ1 is similar:\
We load the IEQ1 terms and weights and sort them by weight in decreasing order. Then, we go term by term and tweak the weight to 0. If this causes an increase in AP or the AP remains same, we accept the tweak, i.e. we eliminate the term, otherwise we revert it.

Henceforth, this method will be referred to as *IEQ1Pruned*.

#remark(title: "Computationally Expensive")[Just like the generation and pruning of IEQ0, pruning IEQ1 is also computationally expensive. Hence, we limit IEQ1 too to `num_expansion_terms`=200 for pruning.]

=== MAP achieved
Compared to IEQ1 (with `num_expansion_terms`=200), which had a MAP of 0.8197, pruning helped the MAP significantly in this case, increasing it to *0.9055*. Refer @table:map_of_ieqs.

== Effect on sizes of the Ideal Expanded Queries (IEQs)
IEQ0 and IEQ1 (with `num_expansion_terms`=200) queries had a constant size of 200 terms.\

Pruning had significant effects on the sizes of many of the IEQs. 
Many of them became very short, some of them even containing only 10-20 terms while still giving very high AP. While still some of them also had very small decreases in size.

*Size of Pruned IEQs found to be highly correlated to the number of relevant documents*:\
Interestingly, the size of IEQ0Pruned and IEQ1Pruned queries were highly positively correlated to the number of relevant documents as we see in this plot:

#figure(
  image("../images/numrel_vs_numterms.png", width: 65%),
  caption: [No. of terms in query _vs._ No. of relevant documents]
)

== Correlation Results
=== `l2_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0Pruned*][*IEQ1Pruned*],
    [Pearson],[0.3451],[0.4082],
    [Kendall],[0.2743],[0.3121],
    [Spearman],[0.3480],[0.3931]
  ),
  caption: [Average Correlations for IEQ0Pruned and IEQ1Pruned (using `l2_similarity`)]
)
=== `l1_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0Pruned*][*IEQ1Pruned*],
    [Pearson],[-0.1942],[0.2847],
    [Kendall],[-0.1472],[0.2070],
    [Spearman],[-0.1898],[0.2722]
  ),
  caption: [Average Correlations for IEQ0Pruned and IEQ1Pruned (using `l1_similarity`)]
)
=== `jaccard_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0Pruned*][*IEQ1Pruned*],
    [Pearson],[0.3239],[0.2591],
    [Kendall],[0.2424],[0.2015],
    [Spearman],[0.3226],[0.2667]
  ),
  caption: [Average Correlations for IEQ0Pruned and IEQ1Pruned (using `jaccard_similarity`)]
)
=== `n2_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0Pruned*][*IEQ1Pruned*],
    [Pearson],[0.2941],[0.2606],
    [Kendall],[0.2346],[0.1989],
    [Spearman],[0.3078],[0.2622]
  ),
  caption: [Average Correlations for IEQ0Pruned and IEQ1Pruned (using `n2_similarity`)]
)

*Conclusion*: As we see, this also did not result in an improve in correlations.
