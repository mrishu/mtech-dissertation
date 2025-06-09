#heading(level: 2, outlined: false, numbering: none)[Abstract]

Query Expansion (QE) techniques aim to mitigate vocabulary mismatch in Information Retrieval by augmenting user queries with related terms. However, their effectiveness varies across queries. This work investigates the explainability of QE by introducing the concept of an Ideal Expanded Query (IEQ): a hypothetical query yielding near-perfect retrieval performance, measured via Average Precision (AP). We hypothesize that the closer a QE variant is to the IEQ, the higher its AP. We generate multiple QE variants using methods like RM3, SPL, CEQE, and Log-Logistic, and compare them to IEQs constructed using Oracle Rocchio tuning and Logistic Regression.

*The codebase for this project is located at*: https://github.com/mrishu/py-qe-explain
