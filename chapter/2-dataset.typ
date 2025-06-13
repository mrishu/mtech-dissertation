// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *
#set quote(block: true)

= Dataset Used <chap:dataset>
The *Robust 2004* dataset is a benchmark collection which consists of a large set of news articles and government documents designed to evaluate the robustness of information retrieval models.

The dataset includes:
+ 250 topics (queries and their descriptions),
+ a corpus of 528,155 documents,
+ relevance information for 249 of the queries (in a `qrel` file).

#quote()[
The TREC Robust retrieval task focuses on "improving the consistency of retrieval technology by focusing on poorly performing topics."
]

#remark(title: "Dataset Link")[
https://ir-datasets.com/trec-robust04.html]
