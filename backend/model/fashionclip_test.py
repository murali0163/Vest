
from pathlib import Path
import torch
import open_clip
from PIL import Image

BASE_DIR = Path(__file__).resolve().parents[1]
IMAGE_DIR = BASE_DIR / "data" / "deepfashion" / "img"

MODEL_NAME = "hf-hub:Marqo/marqo-fashionCLIP"

torch.set_num_threads(4)

print("Loading FashionCLIP...")

model, _, preprocess = open_clip.create_model_and_transforms(
    MODEL_NAME,
    device="cpu"
)

tokenizer = open_clip.get_tokenizer(MODEL_NAME)
model.eval()

print("Model loaded!")

# Different clothing categories
test_images = {
    "Blouse": IMAGE_DIR / "Sheer_Pleated-Front_Blouse" / "img_00000001.jpg",
    "Dress": IMAGE_DIR / "Textured_Floral_Bodycon_Dress" / "img_00000046.jpg",
}

descriptions = [
    "a blouse",
    "a dress",
    "a t-shirt",
    "a skirt",
    "a jacket",
    "a pair of jeans",
]

text_tokens = tokenizer(descriptions)

with torch.inference_mode():

    text_features = model.encode_text(
        text_tokens,
        normalize=True
    )

    for category, image_path in test_images.items():

        if not image_path.exists():
            print("Image missing:", image_path)
            continue

        image = Image.open(image_path).convert("RGB")
        image_tensor = preprocess(image).unsqueeze(0)

        image_features = model.encode_image(
            image_tensor,
            normalize=True
        )

        scores = (image_features @ text_features.T).squeeze(0)

        results = sorted(
            zip(descriptions, scores.tolist()),
            key=lambda x: x[1],
            reverse=True
        )

        print(f"\nActual category: {category}")
        print("Image:", image_path.name)

        for description, score in results:
            print(f"{description}: {score:.4f}")
