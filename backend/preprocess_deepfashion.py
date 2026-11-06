from pathlib import Path
import pandas as pd


# ============================================================
# PATHS
# ============================================================

BASE_DIR = Path(__file__).resolve().parent

ANNOTATIONS_DIR = (
    BASE_DIR
    / "data"
    / "deepfashion"
    / "Annotations"
)

OUTPUT_DIR = (
    BASE_DIR
    / "data"
    / "deepfashion"
    / "processed"
)

OUTPUT_FILE = OUTPUT_DIR / "deepfashion_metadata.csv"


# ============================================================
# ANNOTATION FILES
# ============================================================

ATTR_IMG_FILE = ANNOTATIONS_DIR / "list_attr_img.txt"
ATTR_CLOTH_FILE = ANNOTATIONS_DIR / "list_attr_cloth.txt"

CATEGORY_IMG_FILE = ANNOTATIONS_DIR / "list_category_img.txt"
CATEGORY_CLOTH_FILE = ANNOTATIONS_DIR / "list_category_cloth.txt"


# ============================================================
# HELPER FUNCTION
# ============================================================

def read_annotation_file(path):
    """
    Read a DeepFashion annotation file.

    The first line contains the number of entries.
    The second line contains column names.
    Remaining lines contain the actual data.
    """

    with open(
        path,
        "r",
        encoding="utf-8",
        errors="ignore",
    ) as file:

        # Number of entries
        total_entries = int(file.readline().strip())

        # Header
        header = file.readline().strip().split()

        # Remaining data
        data = []

        for line in file:
            line = line.rstrip()

            if not line:
                continue

            data.append(line)

    return total_entries, header, data


# ============================================================
# READ ATTRIBUTE NAMES
# ============================================================

print("Reading clothing attributes...")

with open(
    ATTR_CLOTH_FILE,
    "r",
    encoding="utf-8",
    errors="ignore",
) as file:

    attribute_count = int(file.readline().strip())

    # Skip header
    file.readline()

    attribute_names = []

    for line in file:
        line = line.rstrip()

        if not line:
            continue

        # Attribute name can contain spaces.
        # The last value is attribute_type.
        parts = line.rsplit(maxsplit=1)

        attribute_name = parts[0]

        attribute_names.append(attribute_name)


print(f"Found {len(attribute_names)} attributes.")


# ============================================================
# READ CATEGORY NAMES
# ============================================================

print("Reading clothing categories...")

with open(
    CATEGORY_CLOTH_FILE,
    "r",
    encoding="utf-8",
    errors="ignore",
) as file:

    category_count = int(file.readline().strip())

    # Skip header
    file.readline()

    category_names = {}

    for index, line in enumerate(file, start=1):

        line = line.rstrip()

        if not line:
            continue

        # Category name + category type
        parts = line.rsplit(maxsplit=1)

        category_name = parts[0]

        category_names[index] = category_name


print(f"Found {len(category_names)} categories.")


# ============================================================
# READ CATEGORY FOR EACH IMAGE
# ============================================================

print("Reading image categories...")

category_rows = []

with open(
    CATEGORY_IMG_FILE,
    "r",
    encoding="utf-8",
    errors="ignore",
) as file:

    image_count = int(file.readline().strip())

    # Skip header
    file.readline()

    for line in file:

        line = line.rstrip()

        if not line:
            continue

        parts = line.split()

        image_path = parts[0]
        category_id = int(parts[1])

        category_name = category_names.get(
            category_id,
            "Unknown",
        )

        category_rows.append(
            {
                "image_path": image_path,
                "category_id": category_id,
                "category": category_name,
            }
        )


print(f"Found categories for {len(category_rows)} images.")


# ============================================================
# READ ATTRIBUTES FOR EACH IMAGE
# ============================================================

print("Reading image attributes...")
print("This may take some time because the file is large.")

attribute_rows = []

with open(
    ATTR_IMG_FILE,
    "r",
    encoding="utf-8",
    errors="ignore",
) as file:

    attr_image_count = int(file.readline().strip())

    # Skip header
    file.readline()

    processed = 0

    for line in file:

        line = line.rstrip()

        if not line:
            continue

        parts = line.split()

        image_path = parts[0]

        attribute_values = parts[1:]

        attributes = []

        for index, value in enumerate(attribute_values):

            if index >= len(attribute_names):
                break

            # DeepFashion uses 1 for present
            # and -1 for not present.
            if value == "1":
                attributes.append(
                    attribute_names[index]
                )

        attribute_rows.append(
            {
                "image_path": image_path,
                "attributes": "|".join(attributes),
            }
        )

        processed += 1

        if processed % 25000 == 0:
            print(
                f"Processed {processed} / "
                f"{attr_image_count} images..."
            )


print(
    f"Finished reading attributes for "
    f"{len(attribute_rows)} images."
)


# ============================================================
# CONVERT TO DATAFRAMES
# ============================================================

print("Creating metadata table...")

category_df = pd.DataFrame(category_rows)

attribute_df = pd.DataFrame(attribute_rows)


# ============================================================
# MERGE CATEGORY + ATTRIBUTES
# ============================================================

print("Combining category and attribute information...")

metadata_df = category_df.merge(
    attribute_df,
    on="image_path",
    how="left",
)


# ============================================================
# ADD FULL IMAGE PATH
# ============================================================

metadata_df["image_file"] = (
    BASE_DIR
    / "data"
    / "deepfashion"
    / metadata_df["image_path"]
)


# Convert Path objects to strings
metadata_df["image_file"] = (
    metadata_df["image_file"].astype(str)
)


# ============================================================
# SAVE
# ============================================================

OUTPUT_DIR.mkdir(
    parents=True,
    exist_ok=True,
)

metadata_df.to_csv(
    OUTPUT_FILE,
    index=False,
    encoding="utf-8",
)


# ============================================================
# SUMMARY
# ============================================================

print()
print("=" * 60)
print("DEEPFASHION PREPROCESSING COMPLETE")
print("=" * 60)

print(f"Images:       {len(metadata_df)}")
print(f"Categories:   {metadata_df['category'].nunique()}")
print(f"Attributes:   {len(attribute_names)}")

print()
print("Category examples:")

print(
    metadata_df[
        ["image_path", "category", "attributes"]
    ].head(10).to_string(index=False)
)

print()
print("Output file:")
print(OUTPUT_FILE)