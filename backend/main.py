from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

from model.recommender import VestRecommender


# ============================================================
# APP
# ============================================================

app = FastAPI(
    title="Vest Recommendation API",
    description=(
        "AI-based fashion recommendation backend "
        "for Vest"
    ),
    version="1.0.0",
)


# ============================================================
# CORS
# ============================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================
# PATHS
# ============================================================

BASE_DIR = Path(__file__).resolve().parent

DEEPFASHION_IMAGE_DIR = (
    BASE_DIR
    / "data"
    / "deepfashion"
    / "img"
)


# ============================================================
# SERVE DEEPFASHION IMAGES
# ============================================================

app.mount(
    "/deepfashion-images",
    StaticFiles(
        directory=DEEPFASHION_IMAGE_DIR
    ),
    name="deepfashion-images",
)


# ============================================================
# RECOMMENDER
# ============================================================

print(
    "Starting Vest recommendation system..."
)

recommender = VestRecommender()


# ============================================================
# REQUEST MODEL
# ============================================================

class RecommendationRequest(BaseModel):

    skin_tone: str
    occasion: str
    outfit_type: str
    style: str
    top_k: int = 5


# ============================================================
# ROOT
# ============================================================

@app.get("/")
def home():

    return {
        "message":
            "Vest Recommendation API is running",

        "status":
            "success",
    }


# ============================================================
# HEALTH
# ============================================================

@app.get("/health")
def health():

    return {
        "status": "healthy",

        "datasets": [
            "Meesho",
            "DeepFashion",
        ],

        "model": (
            "Rule-Based Dataset Routing + "
            "TF-IDF + Cosine Similarity + "
            "Feature Ranking"
        ),
    }


# ============================================================
# RECOMMENDATION
# ============================================================

@app.post("/recommend")
def recommend(
    request: RecommendationRequest,
):

    result = recommender.recommend(

        skin_tone=request.skin_tone,

        occasion=request.occasion,

        outfit_type=request.outfit_type,

        style=request.style,

        top_k=request.top_k,
    )

    return {

        "user_profile": {

            "skin_tone":
                request.skin_tone,

            "occasion":
                request.occasion,

            "outfit_type":
                request.outfit_type,

            "style":
                request.style,
        },

        "source":
            result["source"],

        "recommendations":
            result["recommendations"],
    }