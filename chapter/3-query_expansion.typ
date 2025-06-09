// package imports
#import "@preview/lovelace:0.3.0": *

// own imports
#import "../customization/great-theorems-customized.typ": *


= Vocabulary Mismatch Problem and Query Expansion

== Vocabulary Mismatch Problem

The *vocabulary mismatch problem* occurs when users and relevant documents use different words to express the same concept. This is a major hurdle in information retrieval. Even if a document is relevant, it may not be retrieved simply because it doesn't share the same vocabulary as the query.

#example(title: "Vocabulary Mismatch")[
A user searches for: `laptop overheating`.

But the relevant documents might use terms like: `thermal throttling`, `cooling issues`, or `fan problems`.

Since these terms don’t exactly match the user’s query, the documents may not appear in search results. This hurts the system's recall.
]

== What is Query Expansion?

*Query Expansion (QE)* aims to solve this problem by adding related words or phrases to the user's original query. The goal is to capture different ways the same idea might be expressed in the document collection, improving recall and precision.

#example(title: "Query Expansion")[
Original Query:
`laptop overheating`

After Query Expansion:
`laptop overheating thermal throttling fan problems cooling issues`.

This reformulated query is more likely to match relevant documents.
]

== Query Expansion Techniques

Several algorithms exist for expanding queries. These techniques can be broadly categorized into:

=== Relevance Feedback (RF)

Relevance Feedback methods use *user input*. The user manually marks some retrieved documents as relevant or not relevant. The system then uses this feedback to improve the query.

*Pros*:
- High-quality feedback
- Personalized improvements

*Cons*:
- Requires user interaction
- Slower in real-world systems

#definition(title: "Rocchio Relevance Feedback")[
The *Rocchio algorithm* is a classic relevance feedback technique used to improve search queries in vector space models. It updates the original query vector based on user-marked relevant and non-relevant documents:

$ bold(q_"new") = alpha bold(q_"orig") + beta / (|D_r|) sum_(bold(d_i) in D_r) bold(d_i) - gamma / (|D_"nr"|) sum_(bold(d_j) in D_"nr") bold(d_j) $

Here:
- $bold(q_"new")$ is the modified query vector.
- $bold(q_"orig")$ is the original query vector.
- $D_r $ and $D_"nr"$ are sets of relevant and non-relevant documents.
- $alpha$, $beta$, and $gamma$ are hyperparameters that balance the contributions.
]<definition:rocchio>

The Rocchio method effectively pushes the query vector closer to relevant documents and away from non-relevant ones in the vector space.


=== Pseudo-Relevance Feedback (PRF)

Pseudo-Relevance Feedback assumes that the *top-ranked documents* returned by an initial query are likely relevant. It uses them to find expansion terms, without requiring explicit user feedback.

*Pros*:
- Fully automatic
- Works in most real-world systems

*Cons*:
- May propagate errors if many documents in the top results are non-relevant

=== Thesaurus-Based Expansion

This method uses resources like WordNet or domain-specific thesauri to expand a query with synonyms or related terms.

For example, a query containing `car` may be expanded to include `automobile`, `vehicle`, or `motorcar`.

*Pros*:
- Fully automatic after the thesaurus has been created
- Simple and interpretable

*Cons*:
- May introduce noise due to context-insensitive synonyms
- Limited by the coverage of the thesaurus

=== Co-Occurrence Analysis

This technique expands queries using terms that frequently co-occur with the query terms in a large corpus. It assumes that terms that appear together in similar contexts are semantically related.

*Example*: If `virus` often co-occurs with `infection`, `flu`, and `symptom` in documents, these terms may be good candidates for expansion.

*Pros*:
- Fully automatic
- Reflects corpus-specific language usage

*Cons*:
- May include spurious associations

== QE Techniques Used in This Work

Here are the query expansion methods analyzed in this dissertation:

• *RM3 (Relevance Model 3)*
A probabilistic *pseudo-relevance feedback* method: it takes the top search results, finds commonly occurring terms with the original query, and adds those terms to improve retrieval.

• *SPL (Smooth Power‑Law)*  
A statistical method that models how often words appear using a *smoothed power‑law distribution*. It selects useful terms that follow this natural frequency pattern, helping to catch important but less frequent words.

• *Log‑Logistic Model*
Uses a *log‑logistic distribution* to analyze word frequency patterns. It chooses expansion terms whose occurrence matches the statistical behavior of relevant terms.

• *CEQE (Contextualized Embeddings for Query Expansion)*
A modern neural method using models like *BERT* to understand the query’s meaning. It finds context-aware terms for expansion, capturing semantic nuances and improving results.

