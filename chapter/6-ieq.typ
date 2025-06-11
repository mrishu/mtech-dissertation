// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *

= Ideal Query Generation
== Oracle Rocchio Vector tuning
We present the first algorithm for generating an *Ideal Expanded Query (IEQ)*:
+ This method first constructs the _oracle_ *Rocchio Vector* using the ground truth, which is obtained from the `qrel` file.
  See @definition:rocchio. The document vectors are assumed to have BM25 weights.
+ We sort the terms of the Rocchio vector by their weights in decreasing order and trim the Rocchio vector upto top `num_expansion_terms`.
+ We then select a `tweak_magnitude` from a `list_of_magnitudes`.
+ We iteratively go over the terms of the Rocchio vector one by one and tweak its weight by\ `new_weight = `(1 + `tweak_magnitude`) $times$ `current_weight`.\
  If the AP after tweaking is higher than the AP before tweaking, we accept the tweak. Otherwise we revert it.
+ After we have gone over all the terms, we select the next `tweak_magnitude` and repeat this process.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  pseudocode-list(booktabs: true, numbered-title: [#smallcaps[Oracle Rocchio Tuning]])[
    - *Input*: `qid`, `list_of_magnitudes`, `num_expansion_terms`, `ground_truth`
    - #text(luma(100))[_\# The `ground_truth` is the `qrel` information._]
    - #text(luma(100))[_\# It can be a `dictionary` which maps `qid` $arrow$ `dictionary(docid` $arrow$ `relevance)`._]
    + Construct _oracle_ Rocchio Vector `rocchio_vector` for query ID `qid` using `ground_truth`.
    - #text(luma(100))[_\# `rocchio_vector` is a `dictionary` which maps `term` $arrow$ `weight`._]
    + `rocchio_vector.sort_by_weight(reverse=True)` #text(luma(100))[_\# sort by weights in decreasing order_]
    + `rocchio_vector.trim(num_expansion_terms)`  #text(luma(100))[_\# trim upto top `num_expansion_terms` terms_]
    + `current_AP = computeAP(rocchio_vector, ground_truth)`
    + *for* `tweak_magnitude` *in* `list_of_magnitudes`:
      + *for* `term` *in* `rocchio_vector`:
        + `current_weight = rocchio_vector[term]`
        + `rocchio_vector[term]` = (1 + `tweak_magnitude`) $times$ `current_weight`
        + `nudged_AP = computeAP(rocchio_vector, ground_truth)`
        + *if* `nudged_AP >= current_AP`:
            + `current_AP = nudged_AP`
        + *else*:
            + `rocchio_vector[term] = current_weight`
        + *endif*
      + *end for*
    + *end for*
    + *return* `rocchio_vector`
  ],
)<algo:oracle_rocchio>

#remark(title: "AP Computation")[
The `computeAP(rocchio_vector, ground_truth)` function first retrieves the top 1000 results for the given `rocchio_vector` query
using BM25 retrieval. It then creates a temporary `run` file and compares the retrieved results to the `ground_truth`
using a tool like `trec_eval` to compute and return the AP.
]

The hyperparameters mentioned were taken to be:
- For _oracle_ Rocchio vector construction, $alpha=2.0, beta=64.0, gamma=64.0$.
- `list_of_magnitudes` $=[4.0, 2.0, 1.0, 0.5]$.
- `num_expansion_terms` $= 200$.

Henceforth, this method will be referred to as *IEQ0*.

#remark(title: "IEQ0 is computationally expensive")[
  Since, generation of IEQ0 involves retrieval multiple times, it is computationally expensive. Hence, we limit it to `num_expansion_terms`=200.
]

== Logistic Regression based Ideal Query Generation
We now present the second algorithm for generating IEQs:
+ Read the `qrel` file to collect the relevant and non-relevant documents for query ID `qid`.
+ Construct document vectors for each of the relevant and non-relevant documents using BM25 weights.
+ Construct design matrix $bold(X)$ by stacking all the relevant and non-relevant document vectors.
+ Construct target label $bold(y)$, which is a vector of ones and zeros, where $bold(y)_i = 1$ if the $i$th document is relevant and $bold(y)_i = 0$ otherwise.
+ Do feature selection using Variance Thresholding (where we eliminate terms/features having variance less than `variance_threshold`).
  After that, we again do feature selection using $chi^2$ test and select the `num_after_chi2_terms` - best terms.
+ Fit a Logistic Regression model on the data $bold(X)$ and $bold(y)$.
+ Finally, we use the Logistic Regression model coefficients as weights and their corresponding terms in our IEQ.

#remark(title: "Negative coefficients")[
  Since the model can have negative coefficients, we simply ignore them during retrieval. We select the highest positive `num_expansion_terms` number of terms and use that during retrieval.
]
#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  pseudocode-list(booktabs: true, numbered-title: [#smallcaps[IEQ using Logistic Regression]])[
    - *Input*: `qid`, `qrel`, `variance_threshold`, `num_after_chi2_terms`, `num_expansion_terms`
    + Extract relevant and non-relevant documents for `qid` from `qrel` and construct BM25-weighted document vectors
    + Build design matrix $bold(X)$ by stacking all document vectors
    + Build label vector $bold(y)$: $y_i = 1$ if document $i$ is relevant, else $0$
    - #text(luma(100))[_\# Apply feature selection using variance thresholding and $chi^2$ test_]
    + Apply `VarianceThreshold(threshold=variance_threshold)` on $bold(X)$
    + Apply `SelectKBest(chi2, k=num_after_chi2_terms)` on the reduced $bold(X)$
    - #text(luma(100))[_\# Fit *LogisticRegression* model_]
    + `model = LogisticRegression(solver="liblinear", penalty="l2").fit(`$bold(X)$, $bold(y)$`)`
    + Let `coef = model.coef_`  \# extract the coefficients of trained logistic regression model
    + Select top `num_expansion_terms` terms with highest positive coefficients
    + *return* `query_vector` with selected terms and corresponding weights from `coef`
  ],
)<algo:logistic_ieq>

#remark(title: "Keeping care of terms during feature selection")[
  During feature selection, the terms which are being eliminated and rearranged need to be taken care of. The order of coefficients must correspond to their terms, otherwise it will be incorrect.
]

#note(title: "Motivation")[
  In logistic regression, the classification decision is based on the value of $sigma(w dot x + b)$. Since relevant documents are labeled $1$, the model ideally pushes $w dot x + b >> 0$ for relevant instances. My intuition was:
- If we substitute $x = w$, then the model output becomes $sigma(w dot w + b) = sigma(||w||^2 + b)$, which should be close to $1$ if $||w||^2$ is large.
- Hence, $w$ can be interpreted as a pseudo-relevant document, or a good representation of the relevant set, thereby making it a candidate for an _Ideal Query_.
- $sigma(b)$ gives the probability of an empty document being relevant (as $sigma(w dot x + b) = sigma(b)$ when $x=0$).\
  I expected $b approx 0$ or $sigma(b) approx 0.5$, because this means that the model cannot distinguish an empty document to be relevant or non-relevant.\
  Empirically, I observed that $|b|$ was small for all queries.

This motivation aligned with the results but might be flawed.
]

The hyperparameters mentioned were taken to be:
- `variance_threshold` = $10^(-4)$.
- `num_after_chi2_terms` = $10000$.
- `num_expansion_terms` = $1000$ or $200$.

Henceforth, this method will be referred to as *IEQ1*.

== MAP comparison
#figure(
  table(
    columns: (auto, auto, auto),
    table.header[*IEQ*][*`num_expansion_terms`*][*MAP across 250 queries*],
    [Untweaked Oracle Rocchio], [200], [0.5121],
    [Untweaked Oracle Rocchio], [1000], [0.5465],
    [IEQ0], [200], [0.8919],
    [IEQ1], [1000], [0.9026],
    [IEQ1], [200], [0.8197]
  ),
  caption: [MAP of IEQs]
)<table:map_of_ieqs>
We see both IEQ0 and IEQ1 achieve very high MAPs.

In the figure below, we have plotted,\
AP achieved on individual queries _vs._ $ln$(No. of relevant documents for the query)\
for both IEQ0 and IEQ1 (with `num_expansion_terms`=1000).
#figure(
  image("../images/numrel_vs_ap.png", width: 70%),
  caption: [AP _vs._ $ln$(No. of relevant documents) for IEQs]
)
The main observation is that in both cases:\
*IEQ performs worse as the number of relevant documents increases.*
