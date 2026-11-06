from pathlib import Path
import pandas as pd


# ============================================================
# PATHS
# ============================================================

BASE_DIR = Path(__file__).resolve().parent

INPUT_FILE = (
    BASE_DIR
    / "data"
    / "deepfashion"
    / "processed"
    / "deepfashion_metadata.csv"
)

OUTPUT_DIR = (
    BASE_DIR
    / "data"
    / "deepfashion"
    / "processed"
)

CATEGORY_OUTPUT = OUTPUT_DIR / "category_summary.csv"
ATTRIBUTE_OUTPUT = OUTPUT_DIR / "attribute_summary.csv"


# ============================================================
# LOAD DATA
# ============================================================

print("=" * 60)
print("DEEPFASHION DATASET ANALYSIS")
print("=" * 60)

print("\nLoading metadata...")

df = pd.read_csv(INPUT_FILE)

print(f"Total images: {len(df):,}")


# ============================================================
# BASIC INFORMATION
# ============================================================

print("\n" + "=" * 60)
print("1. BASIC DATASET INFORMATION")
print("=" * 60)

print(f"Rows:        {len(df):,}")
print(f"Columns:     {len(df.columns)}")
print(f"Categories:  {df['category'].nunique()}")
print(f"Attributes:  1000 possible attributes")


# ============================================================
# CATEGORY ANALYSIS
# ============================================================

print("\n" + "=" * 60)
print("2. CATEGORY ANALYSIS")
print("=" * 60)

category_counts = (
    df["category"]
    .value_counts()
    .reset_index()
)

category_counts.columns = [
    "category",
    "image_count",
]

print("\nAll categories:\n")

print(
    category_counts.to_string(index=False)
)

category_counts.to_csv(
    CATEGORY_OUTPUT,
    index=False,
)


# ============================================================
# ATTRIBUTE PROCESSING
# ============================================================

print("\n" + "=" * 60)
print("3. ATTRIBUTE ANALYSIS")
print("=" * 60)

print("\nSplitting attributes...")

# Remove missing values
attribute_series = (
    df["attributes"]
    .fillna("")
    .astype(str)
)

# Convert:
# "pleated|sheer|v-neck"
# into individual attributes
all_attributes = (
    attribute_series
    .str.split("|")
    .explode()
    .str.strip()
)

# Remove empty values
all_attributes = all_attributes[
    all_attributes != ""
]


# ============================================================
# ATTRIBUTE FREQUENCY
# ============================================================

attribute_counts = (
    all_attributes
    .value_counts()
    .reset_index()
)

attribute_counts.columns = [
    "attribute",
    "image_count",
]

print(
    f"\nUnique attributes actually present: "
    f"{len(attribute_counts)}"
)

print("\nTop 50 attributes:\n")

print(
    attribute_counts
    .head(50)
    .to_string(index=False)
)

attribute_counts.to_csv(
    ATTRIBUTE_OUTPUT,
    index=False,
)


# ============================================================
# ATTRIBUTE COVERAGE
# ============================================================

print("\n" + "=" * 60)
print("4. ATTRIBUTE COVERAGE")
print("=" * 60)

images_with_attributes = (
    (attribute_series != "")
    .sum()
)

images_without_attributes = (
    (attribute_series == "")
    .sum()
)

print(
    f"Images with attributes:    "
    f"{images_with_attributes:,}"
)

print(
    f"Images without attributes: "
    f"{images_without_attributes:,}"
)


# ============================================================
# NUMBER OF ATTRIBUTES PER IMAGE
# ============================================================

attribute_count_per_image = (
    attribute_series
    .apply(
        lambda x:
        0 if not x
        else len(x.split("|"))
    )
)

print("\n" + "=" * 60)
print("5. ATTRIBUTES PER IMAGE")
print("=" * 60)

print(
    f"Average attributes/image: "
    f"{attribute_count_per_image.mean():.2f}"
)

print(
    f"Minimum attributes/image: "
    f"{attribute_count_per_image.min()}"
)

print(
    f"Maximum attributes/image: "
    f"{attribute_count_per_image.max()}"
)

print("\nDistribution:\n")

print(
    attribute_count_per_image
    .value_counts()
    .sort_index()
    .head(20)
    .to_string()
)


# ============================================================
# USEFUL FASHION ATTRIBUTE SEARCH
# ============================================================

print("\n" + "=" * 60)
print("6. POTENTIALLY USEFUL VEST ATTRIBUTES")
print("=" * 60)

# These are NOT labels assigned by DeepFashion.
# We are only searching the existing attribute vocabulary
# for terms potentially useful to Vest.

keyword_groups = {

    "Pattern / Print": [
        "print",
        "printed",
        "floral",
        "stripe",
        "striped",
        "plaid",
        "check",
        "checked",
        "polka",
        "paisley",
        "geometric",
        "abstract",
        "animal",
        "graphic",
        "tie-dye",
    ],

    "Fit / Shape": [
        "fit",
        "fitted",
        "loose",
        "relaxed",
        "oversized",
        "slim",
        "straight",
        "a-line",
        "asymmetric",
        "swing",
        "bodycon",
    ],

    "Design / Detail": [
        "pleated",
        "ruffle",
        "lace",
        "embroidered",
        "embroidery",
        "applique",
        "tassel",
        "fringe",
        "bow",
        "button",
        "pocket",
        "belt",
    ],

    "Neckline": [
        "v-neck",
        "round",
        "crew",
        "sweetheart",
        "halter",
        "turtleneck",
        "collar",
        "off-shoulder",
    ],

    "Sleeve": [
        "sleeveless",
        "short-sleeve",
        "long-sleeve",
        "cap-sleeve",
        "three-quarter",
        "bell-sleeve",
    ],

    "Texture / Material": [
        "woven",
        "textured",
        "denim",
        "leather",
        "silk",
        "cotton",
        "knit",
        "terry",
        "sheer",
    ],
}


# ============================================================
# SEARCH VOCABULARY
# ============================================================

available_attributes = (
    attribute_counts["attribute"]
    .tolist()
)

available_lower = {
    attribute.lower(): attribute
    for attribute in available_attributes
}


for group_name, keywords in keyword_groups.items():

    matches = []

    for attribute in available_attributes:

        attribute_lower = attribute.lower()

        for keyword in keywords:

            if keyword.lower() in attribute_lower:

                matches.append(attribute)
                break

    # Remove duplicates while preserving order
    matches = list(dict.fromkeys(matches))

    print(f"\n{group_name}:")
    print(", ".join(matches[:50]))

    if len(matches) > 50:
        print(
            f"... and {len(matches) - 50} more"
        )


# ============================================================
# EXAMPLE RECORDS
# ============================================================

print("\n" + "=" * 60)
print("7. SAMPLE RECORDS")
print("=" * 60)

sample_columns = [
    "image_path",
    "category",
    "attributes",
]

print(
    df[sample_columns]
    .sample(10, random_state=42)
    .to_string(index=False)
)


# ============================================================
# OUTPUT FILES
# ============================================================

print("\n" + "=" * 60)
print("ANALYSIS COMPLETE")
print("=" * 60)

print("\nGenerated files:")

print(CATEGORY_OUTPUT)
print(ATTRIBUTE_OUTPUT)

print("\nWe now have enough information to design")
print("the DeepFashion feature layer for Vest.")