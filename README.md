# Vest — Personalized Fashion Recommendation System

Vest is a cross-platform mobile app that recommends outfits based on a user's **style preferences, skin tone, occasion, and budget**, powered by an AI/ML recommendation engine.

## Tech Stack

- **Frontend:** Flutter (Android + iOS)
- **Backend:** FastAPI (Python)
- **Database:** PostgreSQL
- **Recommendation Engine:** ML + rule-based hybrid (style, skin tone, occasion, budget)

## Plan of Action

1. Research & finalize dataset / feature set
2. Design DB schema, API contracts, app wireframes
3. Build backend (FastAPI) — auth, profile, recommendation logic
4. Build frontend (Flutter) — onboarding, recommendation feed
5. Integrate & test end-to-end
6. Evaluate against success criteria & document results

## Current Flutter Prototype

The onboarding flow collects an optional age range, clothing-style preference,
and skin tone, followed by a required occasion and outfit type. These choices
remain in memory for the current app session.

When the FastAPI service is available, recommendations and product images come
from its catalog. If the service is unavailable, the app clearly indicates that
it is showing sample picks instead. The local sample catalog is filtered by
exact occasion and outfit type, with an occasion-only fallback when no exact
outfit is available. Age and clothing-section choices are not used by the
current backend; skin tone is sent to its recommender. Sample products have no
photos, and the app labels their illustrated fallback rather than displaying
fixture match percentages.

## References

**Base Paper:**

- Manukalpa & Dissanayake, "A Deep Learning Framework for Personalized Fashion Recommendations Based on Skin Tone Analysis," IJLTEMAS, 2025. https://doi.org/10.51583/IJLTEMAS.2025.1406000112

**Supporting Papers:**

- Satti et al., "OutfitX: A Deep Learning Framework for Personalized Outfit Recommendations," ICDSBS, 2025. https://doi.org/10.1109/ICDSBS63635.2025.11031606
- Ding et al., "Computational Technologies for Fashion Recommendation: A Survey," ACM Computing Surveys, 2024. https://arxiv.org/abs/2306.03395
- Shastry et al., "Occasion and Color-Aware Personalized Outfit Recommendation System with Natural Language Interaction," BIDA 2025, Springer, 2026. https://doi.org/10.1007/978-3-032-07837-7_21
- Arunkumar et al., "Fashion Recommendation System for E-Commerce using Deep Learning Algorithms," ICCCNT, 2024. https://doi.org/10.1109/ICCCNT61001.2024.10724655
- Saed & Teimourpour, "Hybrid-Hierarchical Fashion Graph Attention Network for Compatibility-Oriented and Personalized Outfit Recommendation," arXiv, 2025. https://arxiv.org/abs/2508.11105