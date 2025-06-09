// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *

= Introduction to Information Retrieval

When we type a few words into a search bar: "best sci-fi movies", "laptop overheating", or "how to train a neural network", we expect the system to understand what we mean and return the most useful documents. *Information Retrieval (IR)* is the field of computer science that deals with this task: retrieving relevant information from large collections of unstructured data, typically textual documents.

IR systems are used everywhere, from web search engines to digital libraries, recommendation systems, and various databases. Unlike structured databases like SQL where answers to the queries as well as the queries themselves are explicit and exact, IR systems aim to *rank* documents based on their *relevance* to a given query.

== The Retrieval Process

At the heart of IR is the simple interaction between *queries* and *documents*. A *query* is a short string of text representing a user's _information need_. This could be as concise as "black hole evaporation" or as vague as "best movies". The system's job is to retrieve and rank documents (e.g., web pages, articles, papers) from a large *corpus* so that the most relevant ones appear at the top.

This is done in a few core steps:
1. *Indexing*: Preprocess the corpus (tokenization, stopword removal, stemming/lemmatization), and build an inverted index mapping terms to documents.
2. *Scoring*: Given a query, compute a *relevance score* for each document in the corpus.
3. *Ranking*: Return the top-k documents based on those scores.

The effectiveness of an IR system depends crucially on the *scoring model* used. We discuss two such models below, namely TF-IDF and BM25.

== Vector Space Model

One of the foundational models in IR is the *Vector Space Model*. In the Vector Space Model, both queries and documents are represented as vectors in a high-dimensional space, where each dimension corresponds to a term in the vocabulary. The relevance score between a query and a document is then typically computed using *dot product* or *cosine similarity* (which is the angle between their respective vectors).


#definition(title: "Cosine Similarity")[
Let $bold(A) = (A_1, A_2, ..., A_n)$ and $bold(B) = (B_1, B_2, ..., B_n)$ be vectors. Then, 
$ "CosineSimilarity"(bold(A), bold(B)) = frac(bold(A) dot bold(B), ||bold(A)|| ||bold(B)||) = frac(sum_(i=1)^n A_i B_i, sqrt(sum_(i=1)^n A_i^2) dot sqrt(sum_(i=1)^n B_i^2)) $
]


== Term Weighting Schemes
=== tf-idf

To improve on just term frequency matching, *term weighting schemes* like *tf-idf* are used:
- *tf* reflects how often a term occurs in a document.
- *idf* reflects how rare the term is across the corpus.

The *term frequency* (tf) of a term $t$ in a document $D$ is typically defined as:

$ "tf"(t, D) = f(t, D), $

where:
- $f(t, d)$: Raw count of how many times term $t$ appears in document $d$.

The *inverse document frequency* (idf) is defined as:

$ "idf"(t) = log ((N - n_t + 0.5)/(n_t + 0.5) + 1), $

where:
- $"idf"(t)$: Inverse document frequency of term $t$
- $N$: Total number of documents in the collection
- $n_t$: Number of documents in which term $t$ appears

And the relevance score of a document $D$ for a query $Q$ is given by:
$ "tf-idf"(D,Q) = sum_(t in Q) "tf"(t, D) dot "idf"(t). $

However, tf-idf has limitations and may not perform very well for retrieval.

=== BM25

This led to the development of *BM25*, a retrieval model that has become one of the standard baselines in IR. BM25 scores a document $D$ for a query $Q$ as:

$ "BM25"(D, Q) = sum_(t in Q) "idf"(t) dot (f(t, D) dot (k_1 + 1))/(f(t, D) + k_1 dot (1 - b + b dot (|D|)/("avgdl"))), $

where:
- $f(t, D)$: term frequency of term $t$ in document $D$
- $|D|$: length of document $D$
- $"avgdl"$: average document length in the corpus
- $k_1$, $b$: hyperparameters (commonly $k_1 = 1.2$, $b = 0.75$).

=== Back to the vector space model

In both of these models, the expression that occurs inside the summation can be regarded as the weight of then term $t$ in document $D$, which will be important in our work.
$ "BM25"(D, t) = "idf"(t) dot (f(t, D) dot (k_1 + 1))/(f(t, D) + k_1 dot (1 - b + b dot (|D|)/("avgdl"))). $
Here, $"BM25"(D, t)$ represents the weight of term $t$ in document $D$ when document $D$ is considered as a vector in the Vector Space Model.

== Evaluation

=== Unranked Evaluation

In *unranked retrieval*, the system returns a *set* of documents without any particular order. Two standard metrics used are:

- *Precision*: Measures the fraction of retrieved documents that are actually relevant.

  $ "Precision" = (|"Relevant" inter "Retrieved"|)/(|"Retrieved"|) $

- *Recall*: Measures the fraction of relevant documents that were successfully retrieved.

  $ "Recall" = (|"Relevant" inter "Retrieved"|)/(|"Relevant"|) $

These metrics are important when assessing systems that produce binary outputs (relevant or not), but they don't capture ranking information.

=== Ranked Evaluation

In most real-world scenarios, retrieval systems return a *ranked list* of documents. For such systems, *Mean Average Precision (MAP)* is a preferred evaluation metric.

==== Average Precision (AP)
For a single query, *Average Precision (AP)* is defined as the average of the precision values at the ranks where relevant documents appear.

#definition(title: "Average Precision (AP)")[
Let us assume that the top-$N$ retrieved documents were listed using a information retrieval model. Now let,
- $R subset.eq {1, 2, dots, N}$ be the subset of ranks where relevant documents are found.
- $P@k$ denote the precision at rank $k$, which is the precision considering only top-$k$ retrieved documents.

Then, Average Precision is defined as:

$ "AP" = 1/(|R|) sum_(k in R) P@k. $
]

==== Mean Average Precision (MAP)
For a set of queries, *Mean Average Precision (MAP)* defined as the mean of the APs across all queries.

#definition(title: "Mean Average Precision (MAP)")[
Given a set of queries $Q = {q_1, q_2, dots, q_M}$, the *MAP* is the mean of the APs across all queries:

$ "MAP" = 1/M sum_(i=1)^M "AP"(q_i). $
]
