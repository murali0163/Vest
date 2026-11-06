from pathlib import Path

import faiss
import numpy as np
import open_clip
import torch

from PIL import Image

BASE_DIR = Path(__file__).resolve().parents[1]

INDEX_PATH = BASE_DIR / "embeddings" / "fashion_faiss.index"
METADATA_PATH = BASE_DIR / "embeddings" / "fashion_metadata.csv"

# Load FAISS index
print("Loading FAISS index...")
index = faiss.read_index(str(INDEX_PATH))

# Load metadata
import pandas as pd

metadata = pd.read_csv(METADATA_PATH)

# Load FashionCLIP
print("Loading FashionCLIP...")
model_name = "hf-hub:Marqo/marqo-fashionCLIP"

model, _, preprocess = open_clip.create_model_and_transforms(
    model_name,
    device="cpu"
)

model.eval()
torch.set_num_threads(4)

# Select a test image
query_image_path = Path(
    metadata.iloc[0]["image_file"]
)

print("\nQuery image:", query_image_path)
print("Query category:", metadata.iloc[0]["category"])

image = Image.open(query_image_path).convert("RGB")
image_tensor = preprocess(image).unsqueeze(0)

# Generate query embedding
with torch.inference_mode():
    query_embedding = model.encode_image(
        image_tensor,
        normalize=True
    ).cpu().numpy().astype(np.float32)

# Search similar images
scores, indices = index.search(query_embedding, 6)

print("\nSIMILAR FASHION ITEMS")
print("====================")

for rank, (idx, score) in enumerate(
    zip(indices[0], scores[0]), start=1
):
    item = metadata.iloc[idx]

    print(f"\nRank: {rank}")
    print("Category:", item["category"])
    print("Image:", item["image_file"])
    print("Similarity:", round(float(score), 4))