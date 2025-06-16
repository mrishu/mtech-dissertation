// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *

= Similarity Measures <chap:sim>
We now describe the formulae that we have used in our work to measure the similarity between IEQ and an EQ.
From now, we will assume that both IEQ and EQ are vectors in the Vector Space Model.


== Cosine Similarity

#definition(title: "Cosine Similarity")[
  $ "L2"(bold("IEQ"), bold("EQ")) = frac(bold("IEQ") dot bold("EQ"), ||bold("IEQ")||_2 ||bold("EQ")||_2) $
]
We refer to this as `l2_similarity` throughout.

#remark(title: "Dot product")[
  Note that
  $ bold("IEQ") dot bold("EQ") = sum_(t in bold("IEQ") inter bold("EQ")) "IEQ"_t dot "EQ"_t, $
  where $"IEQ"_t$ and $"EQ"_t$ denote the weights of the term $t$ in $bold("IEQ")$ and $bold("EQ")$ respectively.
]

#remark(title: "L2 norm")[
  Note that
  $ ||bold("EQ")||_2 = sum_(t in bold("EQ") ) sqrt("EQ"_t^2) $
  and for $bold("IEQ")$.
]

== Cosine Similarity variant normalized by $L_1$ norm
#definition(title: "Cosine similarity variant normalized by L1 norm")[
  $ "L1"(bold("IEQ"), bold("EQ")) = frac(bold("IEQ") dot bold("EQ"), ||bold("IEQ")||_1 ||bold("EQ")||_1) $
]
We refer to this as `l1_similarity` throughout.

#remark(title: "L1 norm")[
  Note that,
  $ ||bold("EQ")||_1 = sum_(t in bold("EQ") ) |"EQ"_t|, op("where ") |dot| op(" denotes the absolute value.") $
  and for $bold("IEQ")$.
]


== Jaccard Similarity
#definition(title: "Jaccard Similarity")[
  $ J(bold("IEQ"), bold("EQ")) = frac(|bold("IEQ") inter bold("EQ")|, |bold("IEQ") union bold("EQ")|). $
  Here, $|dot|$ denotes the cardinality of a set.
]
We refer to this as `jaccard_similarity` throughout.

== Modified nDCG similarity
Assume that terms in $bold("IEQ")$ and $bold("EQ")$ are ranked by weights and arranged in descending order.

#definition(title: "nDCG similarity")[\
Let,
$ "DCG" = sum_(t in bold("IEQ") inter bold("EQ")) frac("IEQ"_t times 1000, 1000 + "Rank"_bold("EQ")(t) + 1) $ and
$ "IDCG" = sum_(i=1)^(|bold("EQ")|) frac(bold("IEQ")[i] times 1000, 1000 + i + 1). $
Then,
$ "nDCG"(bold("IEQ"), bold("EQ")) = "DCG" / "IDCG". $

Here, $"Rank"_bold("EQ")(t)$ denotes the rank of term $t$ in $bold("EQ")$.\
And $bold("IEQ")[i]$ denotes the weight of the $i^("th")$ term in $bold("IEQ")$.
]
We refer to this as `n2_similarity` throughout.
