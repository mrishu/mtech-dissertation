// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *

= Similarity Measures
We now describe the similarity measures that we have used in our work to find the similarity between IEQ and a QE.
From now, we will assume that both IEQ and QE are vectors in the Vector Space Model.


== Cosine Similarity

#definition(title: "Cosine Similarity")[
  $ "L2"(bold("IEQ"), bold("QE")) = frac(bold("IEQ") dot bold("QE"), ||bold("IEQ")||_2 ||bold("QE")||_2) $
]
Henceforth, this will be referred to as `l2_similarity`.

#remark(title: "Dot product")[
  Note that,
  $ bold("IEQ") dot bold("QE") = sum_(t in bold("IEQ") inter bold("QE")) "IEQ"_t dot "QE"_t, $
  where $"IEQ"_t$ and $"QE"_t$ denote the weights of the term $t$ in $bold("IEQ")$ and $bold("QE")$ respectively.
]

#remark(title: "L2 norm")[
  Note that,
  $ ||bold("QE")||_2 = sum_(t in bold("QE") ) sqrt("QE"_t^2) $
  Similarly for $bold("IEQ")$.
]

== Cosine Similarity variant normalized by L1 norm
#definition(title: "Cosine similarity variant normalized by L1 norm")[
  $ "L1"(bold("IEQ"), bold("QE")) = frac(bold("IEQ") dot bold("QE"), ||bold("IEQ")||_1 ||bold("QE")||_1) $
]
Henceforth, this will be referred to as `l1_similarity`.

#remark(title: "L1 norm")[
  Note that,
  $ ||bold("QE")||_1 = sum_(t in bold("QE") ) |"QE"_t|, op("where ") |dot| op(" denotes the absolute value.") $
  Similarly for $bold("IEQ")$.
]


== Jaccard Similarity
#definition(title: "Jaccard Similarity")[
  $ J(bold("IEQ"), bold("QE")) = frac(|bold("IEQ") inter bold("QE")|, |bold("IEQ") union bold("QE")|). $
  Here, $|dot|$ denotes the cardinality of a set.
]
Henceforth, this will be referred to as `jaccard_similarity`.

== Modified nDCG similarity
Assume that $bold("IEQ")$ and $bold("QE")$ are ranked by weights and arranged in descending order.

#definition(title: "nDCG similarity")[\
Let,
$ "DCG" = sum_(t in bold("IEQ") inter bold("QE")) frac("IEQ"_t times 1000, 1000 + "Rank"_bold("QE")(t) + 1) $ and
$ "IDCG" = sum_(i=1)^(|bold("QE")|) frac(bold("IEQ")[i] times 1000, 1000 + i + 1). $
Then,
$ "nDCG"(bold("IEQ"), bold("QE")) = "DCG" / "IDCG". $

Here, $"Rank"_bold("QE")(t)$ denotes the rank of term $t$ in $bold("QE")$.\
And $bold("IEQ")[i]$ denotes the weight of the $i^("th")$ term in $bold("IEQ")$.
]
Henceforth, this will be referred to as `n2_similarity`.
