// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *

= Using restricted ground truth for IEQ0 generation
== Problem of overfitting
After looking at the individual terms of IEQ0, we realise that it contains many terms that do not occur in any of the EQs.

- We hypothesize that the algorithm is *overfitting* to the relevant documents. This means that the IEQ might contain terms that occur in only very few relevant documents.
- To mitigate this, we decide to form the initial _oracle_ Rocchio vector using *restricted ground truth*.

Construction of *restricted ground truth*:
+ To construct restricted ground truth, we first retrieve the top-1000 documents for each query using BM25 and generate a`run` file. We use the original queries given in the dataset for this step.
+ We then form a `restricted_qrel` file by going over the original `qrel` file and for each query ID `qid`, and each relevance information for that `qid`, we add the `docid` and its relevance to the `restricted_qrel` file, only if the `docid` occurs in the top-1000 retrieved results in the `run` file.

#note(title: "Rationale for using Restricted Ground Truth")[
Suppose a term $t$ is very peculiar and rare and occurs in only a very few relevant documents. As per our hypothesis, due to
overfitting, there is a good chance that term $t$ will be assigned a high weight in the IEQ as it helps in increasing the AP of the IEQ. But since $t$ is very rare, and QE algorithms first retrieve documents using the initial queries and then build the EQs using the vocabulary of retrieved documents, $t$ has very low chances of appearing in any EQ with significant weight. We want to use the same _retrieved set_ for IEQ construction, thus, reducing the chances of such rare terms appearing in the IEQ.
]

We follow the exact same procedure as @algo:oracle_rocchio, except for Step 1, where we use `restricted_qrel` to construct the initial _oracle_ Rocchio Vector.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  pseudocode-list(booktabs: true, numbered-title: [#smallcaps[Oracle Rocchio Tuning on Restricted Ground Truth]])[
    - *Input*: `qid`, `list_of_magnitudes`, `num_expansion_terms`, `ground_truth`, #text(red)[`restricted_ground_truth`]
    + Construct _oracle_ Rocchio Vector `rocchio_vector` for query ID `qid` using #text(red)[`restricted_ground_truth`].
    + ... the rest of the algorithm remains the same ...
  ],
)<algo:oracle_rocchio_restricted>

Henceforth, this method will be referred to as *IEQ0Restricted*.

The *MAP achieved* by IEQ0Restricted is *0.8256*, which is lower than the MAP achieved by IEQ0 but still very high.

== Correlation results
=== `l2_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ0Restricted*],
    [Pearson],[0.4858],[0.4246], [Kendall],[0.3762],[0.3302], [Spearman],[0.4765],[0.4182]
  ),
  caption: [Average Correlations for IEQ0 and IEQ0Restricted (using `l2_similarity`)]
)
=== `l1_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ0Restricted*],
    [Pearson],[-0.2100],[-0.207],
    [Kendall],[-0.1643],[-0.1601],
    [Spearman],[-0.2079],[-0.2050]
  ),
  caption: [Average Correlations for IEQ0 and IEQ0Restricted (using `l1_similarity`)]
)
=== `jaccard_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ0Restricted*],
    [Pearson],[0.3285],[0.2775],
    [Kendall],[0.2526],[0.2254],
    [Spearman],[0.3334],[0.2938]
  ),
  caption: [Average Correlations for IEQ0 and IEQ0Restricted (using `jaccard_similarity`)]
)
=== `n2_similarity`
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*Correlation Name*][*IEQ0*][*IEQ0Restricted*],
    [Pearson],[0.2746],[0.2001],
    [Kendall],[0.2280],[0.2051],
    [Spearman],[0.2975],[0.2582]
  ),
  caption: [Average Correlations for IEQ0 and IEQ0Restricted (using `n2_similarity`)]
)

*Conclusion*: We see that this doesn't result in improvement in the correlations. This is counter-intuitive because we expected that the restricted ground truth will produce IEQs with better intersection with the EQs.
