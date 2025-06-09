// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *

= Pruning IEQ0
We saw that while constructing IEQ0, we have a `list_of_magnitudes` from where we pick a `tweak_magnitude` and tweak the weights of the terms in the query vector by:
```
new_weight = (1 + tweak_magnitude) * old_weight
```
If the `new_weight` for the term results in an increase in AP, we accept the tweak otherwise we revert it.

Earlier we had, `list_of_magnitudes` $= [4.0, 2.0, 1.0, 0.5]$.\
We modify this list to contain a $-1.0$ at the end so that our\
new `list_of_magnitudes` $=[4.0, 2.0, 1.0, 0.5, -1.0]$.

This has the effect that after normal IEQ0 construction, we tweak the weights of the terms by making them $0$ (essentially eliminating them), and seeing if the AP increases.

Henceforth, this method will be referred to as *IEQ0Pruned*.

== MAP achieved
Since, this process (by constructing) can only improve the MAP compared to IEQ0, we achieve a slightly better MAP than IEQ0: *0.9060*.

== Effect on sizes of the Ideal Expanded Queries (IEQs)
IEQ0 queries had a constant size of 200 terms (as `num_expansion_terms` was 200 for IEQ0).\

This tweak had significant effects on the sizes of some IEQs. 
Many of the IEQs became very short, some of them even containing only 10-20 terms while still giving very high AP. While some of them also had very small decreases in size.

Interestingly, the size of IEQ0Pruned queries was highly positively correlated to the number of relevant documents as we see in this plot:

#figure(
  image("../images/numrel_vs_numterms_ieq0pruned.png", width: 65%),
  caption: [No. of terms in IEQ0Pruned _vs._ No. of relevant documents for IEQ0Pruned]
)
