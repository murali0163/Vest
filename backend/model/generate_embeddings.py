
from pathlib import Path
import time
import gc

import numpy as np
import pandas as pd
import torch
import open_clip
from PIL import Image, ImageFile
from tqdm import tqdm

# ==================================================
# CONFIGURATION
# ==================================================

BASE_DIR = Path(__file__).resolve().parents[1]

METADATA_PATH = (
    BASE_DIR / "data" / "deepfashion"
    / "processed" / "deepfashion_metadata.csv"
)

OUTPUT_DIR = BASE_DIR / "embeddings"

MODEL_NAME = "hf-hub:Marqo/marqo-fashionCLIP"

MAX_IMAGES = 1000       # Initial benchmark
BATCH_SIZE = 8
SAVE_EVERY = 100

OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

ImageFile.LOAD_TRUNCATED_IMAGES = True
torch.set_num_threads(4)

# ==================================================
# LOAD DATA
# ==================================================

print("Loading metadata...")

df = pd.read_csv(METADATA_PATH)

df = df[df["image_file"].apply(
    lambda path: Path(path).is_file()
)].copy()

# Select a balanced sample across categories
# Select a balanced sample from each category
categories = df["category"].unique()
samples_per_category = MAX_IMAGES // len(categories)

sampled_groups = []

for category in categories:
    group = df[df["category"] == category]

    sample = group.sample(
        n=min(len(group), samples_per_category),
        random_state=42
    )

    sampled_groups.append(sample)

df = pd.concat(sampled_groups).reset_index(drop=True)

# Add extra images if needed to reach MAX_IMAGES
if len(df) < MAX_IMAGES:
    remaining_df = pd.read_csv(METADATA_PATH)
    remaining_df = remaining_df[
        remaining_df["image_file"].apply(
            lambda path: Path(path).is_file()
        )
    ]
    remaining_df = remaining_df[
        ~remaining_df["image_file"].isin(df["image_file"])
    ]

    extra_count = min(MAX_IMAGES - len(df), len(remaining_df))

    if extra_count > 0:
        extra = remaining_df.sample(
            n=extra_count,
            random_state=42
        )
        df = pd.concat([df, extra]).reset_index(drop=True)

print("Images selected:", len(df))
df = df.head(MAX_IMAGES).reset_index(drop=True)

print("Images selected:", len(df))

# ==================================================
# LOAD MODEL
# ==================================================

print("\nLoading FashionCLIP...")

device = "cpu"

model, _, preprocess = open_clip.create_model_and_transforms(
    MODEL_NAME,
    device=device
)

model.eval()

print("FashionCLIP ready!")

# ==================================================
# GENERATE EMBEDDINGS
# ==================================================

all_embeddings = []
successful_rows = []

start_time = time.time()

for start in tqdm(
    range(0, len(df), BATCH_SIZE),
    desc="Generating embeddings"
):

    batch = df.iloc[start:start + BATCH_SIZE]

    images = []
    valid_rows = []

    for _, row in batch.iterrows():

        try:
            image = Image.open(
                row["image_file"]
            ).convert("RGB")

            images.append(preprocess(image))
            valid_rows.append(row)

        except Exception as error:
            print(
                "\nSkipping image:",
                row["image_file"],
                error
            )

    if not images:
        continue

    image_batch = torch.stack(images).to(device)

    with torch.inference_mode():

        features = model.encode_image(
            image_batch,
            normalize=True
        )

    all_embeddings.extend(
        features.cpu().numpy().astype(np.float32)
    )

    successful_rows.extend(valid_rows)

    del images, image_batch, features
    gc.collect()

    # Save checkpoint
    if len(successful_rows) % SAVE_EVERY < BATCH_SIZE:
        np.save(
            OUTPUT_DIR / "fashion_embeddings_checkpoint.npy",
            np.array(all_embeddings, dtype=np.float32)
        )

# ==================================================
# SAVE FINAL OUTPUT
# ==================================================

embeddings = np.array(
    all_embeddings,
    dtype=np.float32
)

metadata = pd.DataFrame(successful_rows)

np.save(
    OUTPUT_DIR / "fashion_embeddings.npy",
    embeddings
)

metadata.to_csv(
    OUTPUT_DIR / "fashion_metadata.csv",
    index=False
)

elapsed = time.time() - start_time

print("\n================================")
print("EMBEDDING GENERATION COMPLETED")
print("================================")

print("Successful images:", len(metadata))
print("Embedding shape:", embeddings.shape)
print("Time taken:", round(elapsed / 60, 2), "minutes")
print(
    "Average time per image:",
    round(elapsed / max(len(metadata), 1), 3),
    "seconds"
)
print("Output folder:", OUTPUT_DIR)
