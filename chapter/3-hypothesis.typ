// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *

= Problem Statement and Hypothesis

== Problem Statement  
As mentioned previously, many query expansion algorithms exist, each with its own term selection and weighting schemes. It has been observed that different methods perform differently for different queries. For certain queries, average precision (AP) improves after expansion using a particular algorithm, while for others, it decreases.
The *goal of this work* is to understand, why certain methods perform well for some queries but not others, in a clear and interpretable way.

== Hypothesis  
This work builds on the earlier studies by *Snehasish Mukherjee* @snehasish and *Soumajit Pramanik* @soumajit.

We propose that for each query, there exists an *Ideal Expanded Query (IEQ)* that yields nearly perfect performance (Average Precision close to 1).  

If a real query expansion method produces a query that is *close* to this IEQ (in some quantitative sense), then that EQ is expected to yield higher AP. Conversely, methods that produce queries farther from the IEQ will perform worse.

== Overall Setup

=== Expanded Query (EQ) variants
+ For each query in our dataset (See @dataset), we generated *80 expanded queries* ($4 times 4 times 5 times 1 times 1=80$) using this parameter grid:

  - *Expansion methods* (`expansion_method`): `[rm3, ceqe, loglogistic, spl]`
  - *Number of top documents* (`num_top_docs`): `[10, 20, 30, 40]`: how many retrieved documents are used for feedback
  - *Number of expansion terms* (`num_exp_terms`): `[15, 25, 35, 45, 55]`: how many new terms are added to the query
  - *Mixing parameter* (`mixing_param`): `0.5`: fixed weight for mixing the original query with expansion terms

  Each method also uses a specific `tuning_parameter`:
  #table(
    columns: (auto, auto, auto),
    table.header[*Method*][*Parameter Name*][*Value*],
    [`rm3`], [Feedback weight $beta$], [0.6],
    [`ceqe`], [Embedding-context weight], [0.6],
    [`loglogistic`], [Distribution shape/scale], [2],
    [`spl`], [Smooth power-law factor], [8],
  )

  Each EQ variant is identified by its `qid` and its `runid` which is a string of the form:
  ```
      <expansion_method>-<num_exp_terms>-<num_top_docs>-<tuning_parameter>
  ```
  which describes the expansion method and parameters used to construct that particular variant.
+ For each variant,
  - We generated a `term_weights` file containing the terms with their corresponding weights for each query in `<qid> <term> <weight>` format.
  - We retrieved the top-1000 documents for each query and stored the results in a `run` file containing lines of the form: `<qid> Q0 <docid> <rank> <score> <runid>` format.
  - Using `trec_eval` we generated an `ap` file which contains the AP achieved by all queries in\ `<qid> <AP>` format.

#note(title: "Boosting Queries")[
  Earlier we saw that the BM25 score of a document $D$ with respect to a query $Q$ is given by the formula @eqn:bm25. Here $Q$ is considered as a zero-one vector which just signifies the presence or absence of a term in the query.

  In general, the query $Q$ can have non-negative real valued weights for each term. This is known as *Boosting*. In this case,
  the BM25 score of a document $D$ with respect to a query $Q$ is given by the formula
  $ "BM25"_"boosted" (D, Q) = sum_(t in Q) w_t dot "idf"(t) dot (f(t, D) dot (k_1 + 1))/(f(t, D) + k_1 dot (1 - b + b dot (|D|)/("avgdl"))). $
  - Here $w_t$ denotes the weight of term $t$ in the query $Q$.
]

=== Ideal Query Generation
We then generate the IEQ for each query (using algorithms described later in @chap:iqg). Ideal queries also have their corresponding `term_weights`, `run` and `ap` files.

=== Similarity Measuring and Correlation Computation
+ Firstly, for each query, we measure the similarity between the IEQ and each of the 80 expanded versions of that query (using similarity formulae described later in @chap:sim).
+ For each query we make two lists of length 80,
  - one containing the similarity of each EQ variant to the IEQ,
  - the other containing the corresponding APs achieved by each EQ variant.
    ```
    qid:
      similarity_list = [sim_variant_1, sim_variant_2, ..., sim_variant_80]
      ap_list = [ap_variant_1, ap_variant_2, ..., ap_variant_80]
    ```\
+ Then, we find the Pearson, Kendall and Spearman correlation between these lists.
+ Finally, we take the average of these correlations across all 250 queries and report the average Pearson, Kendall and Spearman correlations.

According to our hypothesis, we expect high correlations between these two lists.

== Software Used
- We used *PyLucene 10.0.0* (with Python 3.11) as the underlying search engine library for indexing and retrieval.
- We used *pytrec_eval* for evaluation of the retrieval results @pytrec_eval.
- We also used *trec_eval* for evaluating retrieval results. Link: https://github.com/usnistgov/trec_eval.
- Other Python libraries include *NumPy*, *SciPy*, *Matplotlib*.
- We used *GNU Parallel* for parallelization.
