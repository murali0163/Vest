from pathlib import Path

import numpy as np
import faiss

BASE_DIR = Path(__file__).resolve().parents[1]
EMBEDDINGS_PATH = BASE_DIR / "embeddings" / "fashion_embeddings.npy"
INDEX_PATH = BASE_DIR / "embeddings" / "fashion_faiss.index"

print("Loading embeddings...")

embeddings = np.load(EMBEDDINGS_PATH).astype(np.float32)

print("Embedding shape:", embeddings.shape)

# Create a FAISS index for cosine similarity
dimension = embeddings.shape[1]

index = faiss.IndexFlatIP(dimension)

# Add normalized embeddings
faiss.normalize_L2(embeddings)
index.add(embeddings)

# Save the index
faiss.write_index(index, str(INDEX_PATH))

print("\nFAISS INDEX CREATED")
print("===================")
print("Total vectors:", index.ntotal)
print("Dimensions:", dimension)
print("Index saved at:", INDEX_PATH)