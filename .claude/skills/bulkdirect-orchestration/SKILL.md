---
name: bulkdirect-orchestration
description: "DAG orchestration patterns — sequential pipeline, parallelization, feedback loops"
origin: ECC
---

# BulkDirect Orchestration

Patterns et architectures pour orchestrer le DAG BulkDirect.

## When to Use

- Coordonner 4 agents en séquence
- Paralleliser Reddit scraping (3–5 verticales)
- Gérer Batch API processing
- Feedback loops depuis QA Reviewer

## Loop Pattern

**Sequential DAG:**
