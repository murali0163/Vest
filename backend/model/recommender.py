from pathlib import Path

import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity


# ============================================================
# PATHS
# ============================================================

BASE_DIR = Path(__file__).resolve().parents[1]

MEESHO_DATA_PATH = (
    BASE_DIR / "data" / "train.csv"
)

DEEPFASHION_DATA_PATH = (
    BASE_DIR
    / "data"
    / "deepfashion"
    / "processed"
    / "deepfashion_metadata.csv"
)


class VestRecommender:

    # ========================================================
    # INITIALIZATION
    # ========================================================

    def __init__(self):

        print("Starting Vest recommendation engine...")

        self._load_meesho()
        self._load_deepfashion()

        print("Recommendation engine ready.")

    # ========================================================
    # MEESHO
    # ========================================================

    def _load_meesho(self):

        print("Loading Meesho dataset...")

        self.meesho_df = pd.read_csv(
            MEESHO_DATA_PATH
        )

        attribute_columns = [
            "Category",
            "attr_1",
            "attr_2",
            "attr_3",
            "attr_4",
            "attr_5",
            "attr_6",
            "attr_7",
            "attr_8",
            "attr_9",
            "attr_10",
        ]

        self.meesho_attribute_columns = (
            attribute_columns
        )

        self.meesho_df[attribute_columns] = (
            self.meesho_df[attribute_columns]
            .fillna("")
        )

        self.meesho_df["feature_text"] = (
            self.meesho_df[
                attribute_columns
            ]
            .astype(str)
            .agg(" ".join, axis=1)
        )

        self.meesho_vectorizer = (
            TfidfVectorizer(
                lowercase=True,
                ngram_range=(1, 2),
                min_df=2,
            )
        )

        self.meesho_vectors = (
            self.meesho_vectorizer.fit_transform(
                self.meesho_df["feature_text"]
            )
        )

        print(
            f"Loaded {len(self.meesho_df)} "
            "Meesho products."
        )

    # ========================================================
    # DEEPFASHION
    # ========================================================

    def _load_deepfashion(self):

        print("Loading DeepFashion metadata...")

        self.deepfashion_df = pd.read_csv(
            DEEPFASHION_DATA_PATH
        )

        self.deepfashion_df[
            "attributes"
        ] = (
            self.deepfashion_df[
                "attributes"
            ]
            .fillna("")
            .astype(str)
        )

        # Combined searchable text
        self.deepfashion_df[
            "feature_text"
        ] = (
            self.deepfashion_df["category"]
            .fillna("")
            .astype(str)
            + " "
            + self.deepfashion_df[
                "attributes"
            ]
        )

        print(
            f"Loaded "
            f"{len(self.deepfashion_df)} "
            "DeepFashion images."
        )

    # ========================================================
    # DATASET ROUTING
    # ========================================================

    # Indian/traditional categories currently use Meesho.
    traditional_outfits = {
        "Kurti & Leggings",
        "Kurti & Palazzo",
        "Anarkali",
        "Lehenga",
        "Indo-Western Set",
        "Kurta Set",
        "Saree",
        "Half Saree",
        "Salwar Kameez",
        "Sherwani",
        "Kurta Pyjama",
    }

    # Western / fashion-image categories use DeepFashion.
    deepfashion_outfits = {

        "T-Shirt & Jeans": [
            "Tee",
            "Jeans",
            "Top",
        ],

        "Casual Dress": [
            "Dress",
        ],

        "Co-ord Set": [
            "Top",
            "Skirt",
            "Shorts",
            "Tee",
        ],

        "Blazer Set": [
            "Blazer",
            "Jacket",
        ],

        "Shirt & Trousers": [
            "Button-Down",
            "Tee",
            "Top",
            "Chinos",
        ],

        "Pencil Skirt Set": [
            "Skirt",
        ],

        "Bodycon Dress": [
            "Dress",
        ],

        "Slip Dress": [
            "Dress",
        ],

        "Jumpsuit": [
            "Jumpsuit",
        ],
    }

    # ========================================================
    # OCCASION KEYWORDS
    # ========================================================

    occasion_keywords = {

        "Everyday": [
            "casual",
            "daily",
            "comfortable",
            "classic",
            "basic",
            "simple",
        ],

        "Work": [
            "formal",
            "classic",
            "blazer",
            "shirt",
            "straight",
            "pencil",
            "collar",
            "tailored",
        ],

        "Date Night": [
            "bodycon",
            "fitted",
            "lace",
            "sheer",
            "dress",
            "romper",
            "jumpsuit",
            "flared",
            "stylish",
        ],

        "Festival": [
            "floral",
            "embroidered",
            "print",
            "printed",
            "woven",
            "lace",
            "maxi",
            "colorful",
        ],

        "Wedding": [
            "lace",
            "embroidered",
            "floral",
            "maxi",
            "woven",
            "embellished",
            "ornate",
            "tassel",
        ],
    }

    # ========================================================
    # STYLE KEYWORDS
    # ========================================================

    style_keywords = {

        "Casual": [
            "casual",
            "classic",
            "cotton",
            "denim",
            "graphic",
            "basic",
            "relaxed",
        ],

        "Formal": [
            "formal",
            "classic",
            "blazer",
            "shirt",
            "collar",
            "pencil",
            "tailored",
        ],

        "Traditional": [
            "embroidered",
            "floral",
            "woven",
            "lace",
            "ethnic",
            "ornate",
        ],

        "Streetwear": [
            "graphic",
            "hoodie",
            "oversized",
            "boxy",
            "denim",
            "jogger",
            "logo",
        ],

        "Minimal": [
            "classic",
            "solid",
            "simple",
            "straight",
            "basic",
            "clean",
        ],

        "Trendy": [
            "crop",
            "cropped",
            "bodycon",
            "pleated",
            "ruffle",
            "graphic",
            "lace",
            "sheer",
            "oversized",
        ],
    }

    # ========================================================
    # SKIN-TONE COLOR PREFERENCES
    # ========================================================

    # These are used as personalization rules.
    # The system searches the actual clothing attributes
    # for these color terms.

    skin_tone_colors = {

        "Porcelain": [
            "navy blue",
            "navy",
            "blue",
            "pink",
            "maroon",
            "purple",
            "green",
            "emerald",
            "grey",
        ],

        "Warm Beige": [
            "peach",
            "coral",
            "yellow",
            "maroon",
            "green",
            "olive",
            "navy blue",
            "navy",
            "red",
        ],

        "Honey": [
            "mustard",
            "yellow",
            "maroon",
            "burgundy",
            "red",
            "green",
            "emerald",
            "navy blue",
            "navy",
            "peach",
            "olive",
        ],

        "Caramel": [
            "mustard",
            "yellow",
            "maroon",
            "burgundy",
            "red",
            "green",
            "emerald",
            "navy blue",
            "navy",
            "orange",
            "rust",
            "peach",
        ],

        "Umber": [
            "maroon",
            "burgundy",
            "red",
            "mustard",
            "yellow",
            "green",
            "emerald",
            "navy blue",
            "navy",
            "white",
            "peach",
            "purple",
        ],

        "Deep Ebony": [
            "maroon",
            "burgundy",
            "wine",
            "red",
            "mustard",
            "yellow",
            "green",
            "emerald",
            "teal",
            "navy blue",
            "navy",
            "blue",
            "white",
            "pink",
            "purple",
            "magenta",
        ],
    }

    # ========================================================
    # MEESHO CATEGORY MAPPING
    # ========================================================

    outfit_category_mapping = {

        "T-Shirt & Jeans": [
            "Men Tshirts",
            "Women Tshirts",
        ],

        "Kurti & Leggings": [
            "Kurtis",
        ],

        "Casual Dress": [
            "Women Tops & Tunics",
            "Women Tshirts",
        ],

        "Co-ord Set": [
            "Women Tops & Tunics",
            "Women Tshirts",
        ],

        "Blazer Set": [
            "Women Tops & Tunics",
        ],

        "Shirt & Trousers": [
            "Men Tshirts",
            "Women Tops & Tunics",
        ],

        "Pencil Skirt Set": [
            "Women Tops & Tunics",
        ],

        "Kurti & Palazzo": [
            "Kurtis",
        ],

        "Bodycon Dress": [
            "Women Tops & Tunics",
        ],

        "Slip Dress": [
            "Women Tops & Tunics",
        ],

        "Jumpsuit": [
            "Women Tops & Tunics",
        ],

        "Anarkali": [
            "Kurtis",
        ],

        "Lehenga": [
            "Sarees",
        ],

        "Indo-Western Set": [
            "Kurtis",
            "Women Tops & Tunics",
        ],

        "Kurta Set": [
            "Kurtis",
        ],

        "Saree": [
            "Sarees",
        ],

        "Half Saree": [
            "Sarees",
        ],

        "Salwar Kameez": [
            "Kurtis",
        ],

        "Sherwani": [
            "Men Tshirts",
        ],

        "Kurta Pyjama": [
            "Men Tshirts",
        ],
    }

    # ========================================================
    # UTILITY
    # ========================================================

    def _keyword_score(
        self,
        text,
        keywords,
    ):

        text = str(text).lower()

        return sum(
            1
            for keyword in keywords
            if keyword.lower() in text
        )

    # ========================================================
    # ROUTER
    # ========================================================

    def _select_source(
        self,
        outfit_type,
    ):

        if outfit_type in self.traditional_outfits:
            return "meesho"

        if outfit_type in self.deepfashion_outfits:
            return "deepfashion"

        return "meesho"

    # ========================================================
    # DEEPFASHION RECOMMENDATION
    # ========================================================

    def _recommend_deepfashion(
        self,
        skin_tone,
        occasion,
        outfit_type,
        style,
        top_k,
    ):

        df = self.deepfashion_df

        allowed_categories = (
            self.deepfashion_outfits.get(
                outfit_type,
                [],
            )
        )

        if not allowed_categories:
            allowed_categories = (
                df["category"]
                .dropna()
                .unique()
                .tolist()
            )

        # ----------------------------------------------------
        # FILTER BY OUTFIT CATEGORY
        # ----------------------------------------------------

        candidates = df[
            df["category"].isin(
                allowed_categories
            )
        ].copy()

        if len(candidates) == 0:
            candidates = df.copy()

        # ----------------------------------------------------
        # USER PREFERENCES
        # ----------------------------------------------------

        occasion_words = (
            self.occasion_keywords.get(
                occasion,
                [],
            )
        )

        style_words = (
            self.style_keywords.get(
                style,
                [],
            )
        )

        skin_words = (
            self.skin_tone_colors.get(
                skin_tone,
                [],
            )
        )

        # ----------------------------------------------------
        # CALCULATE INDIVIDUAL SCORES
        # ----------------------------------------------------

        candidates["skin_score"] = (
            candidates["feature_text"]
            .apply(
                lambda text:
                min(
                    self._keyword_score(
                        text,
                        skin_words,
                    ),
                    3,
                )
            )
        )

        candidates["occasion_score"] = (
            candidates["feature_text"]
            .apply(
                lambda text:
                min(
                    self._keyword_score(
                        text,
                        occasion_words,
                    ),
                    2,
                )
            )
        )

        candidates["style_score"] = (
            candidates["feature_text"]
            .apply(
                lambda text:
                min(
                    self._keyword_score(
                        text,
                        style_words,
                    ),
                    2,
                )
            )
        )

        # ----------------------------------------------------
        # FINAL PERSONALIZATION SCORE
        # ----------------------------------------------------
        #
        # Skin tone is now the strongest
        # personalization factor.
        #
        # Maximum approximate score:
        #
        # Skin tone : 3 x 0.40 = 1.20
        # Occasion  : 2 x 0.25 = 0.50
        # Style     : 2 x 0.20 = 0.40
        #
        # ----------------------------------------------------

        candidates["score"] = (
            candidates["skin_score"] * 0.40
            + candidates["occasion_score"] * 0.25
            + candidates["style_score"] * 0.20
        )

        # ----------------------------------------------------
        # SMALL BONUS FOR ACTUAL COLOR MATCH
        # ----------------------------------------------------

        candidates.loc[
            candidates["skin_score"] >= 1,
            "score",
        ] += 0.15

        # ----------------------------------------------------
        # SORT
        # ----------------------------------------------------

        candidates = (
            candidates
            .sort_values(
                [
                    "score",
                    "skin_score",
                    "occasion_score",
                    "style_score",
                ],
                ascending=False,
            )
            .head(top_k)
        )

        # ----------------------------------------------------
        # BUILD RESPONSE
        # ----------------------------------------------------

        results = []

        for _, row in candidates.iterrows():

            attributes = (
                str(row["attributes"])
                .split("|")
                if row["attributes"]
                else []
            )

            results.append(
                {
                    "id": row["image_path"],

                    "source": "DeepFashion",

                    "category": row["category"],

                    "attributes": attributes,

                    "image_url": (
                        "/deepfashion-images/"
                        + str(
                            row["image_path"]
                        ).replace(
                            "img/",
                            "",
                            1,
                        )
                    ),

                    "score": round(
                        float(row["score"]),
                        4,
                    ),
                }
            )

        return results

    # ========================================================
    # MEESHO RECOMMENDATION
    # ========================================================

    def _recommend_meesho(
        self,
        skin_tone,
        occasion,
        outfit_type,
        style,
        top_k,
    ):

        user_keywords = []

        user_keywords.extend(
            self.occasion_keywords.get(
                occasion,
                [],
            )
        )

        user_keywords.extend(
            self.style_keywords.get(
                style,
                [],
            )
        )

        user_keywords.extend(
            self.skin_tone_colors.get(
                skin_tone,
                [],
            )
        )

        user_keywords.extend(
            self.outfit_category_mapping.get(
                outfit_type,
                [],
            )
        )

        user_text = " ".join(
            user_keywords
        )

        user_vector = (
            self.meesho_vectorizer.transform(
                [user_text]
            )
        )

        similarity = (
            cosine_similarity(
                user_vector,
                self.meesho_vectors,
            ).flatten()
        )

        final_scores = similarity.copy()

        categories = (
            self.outfit_category_mapping.get(
                outfit_type,
                [],
            )
        )

        # ----------------------------------------------------
        # CATEGORY PREFERENCE
        # ----------------------------------------------------

        category_mask = (
            self.meesho_df["Category"]
            .isin(categories)
        )

        final_scores[category_mask] += 0.50

        # ----------------------------------------------------
        # KEYWORD PERSONALIZATION
        # ----------------------------------------------------

        for index, row in (
            self.meesho_df.iterrows()
        ):

            text = str(
                row["feature_text"]
            ).lower()

            occasion_score = (
                self._keyword_score(
                    text,
                    self.occasion_keywords.get(
                        occasion,
                        [],
                    ),
                )
            )

            style_score = (
                self._keyword_score(
                    text,
                    self.style_keywords.get(
                        style,
                        [],
                    ),
                )
            )

            color_score = (
                self._keyword_score(
                    text,
                    self.skin_tone_colors.get(
                        skin_tone,
                        [],
                    ),
                )
            )

            # Skin tone has stronger influence
            final_scores[index] += (
                min(
                    occasion_score,
                    2,
                ) * 0.10
            )

            final_scores[index] += (
                min(
                    style_score,
                    2,
                ) * 0.10
            )

            final_scores[index] += (
                min(
                    color_score,
                    3,
                ) * 0.20
            )

        # ----------------------------------------------------
        # TOP RESULTS
        # ----------------------------------------------------

        top_indices = (
            final_scores
            .argsort()[::-1]
            [:top_k]
        )

        results = []

        for index in top_indices:

            row = (
                self.meesho_df.iloc[index]
            )

            results.append(
                {
                    "id": int(row["id"]),

                    "source": "Meesho",

                    "category": row[
                        "Category"
                    ],

                    "attributes": {
                        "attr_1": row[
                            "attr_1"
                        ],
                        "attr_2": row[
                            "attr_2"
                        ],
                        "attr_3": row[
                            "attr_3"
                        ],
                        "attr_4": row[
                            "attr_4"
                        ],
                        "attr_5": row[
                            "attr_5"
                        ],
                        "attr_6": row[
                            "attr_6"
                        ],
                        "attr_7": row[
                            "attr_7"
                        ],
                        "attr_8": row[
                            "attr_8"
                        ],
                        "attr_9": row[
                            "attr_9"
                        ],
                        "attr_10": row[
                            "attr_10"
                        ],
                    },

                    "image_url": None,

                    "score": round(
                        float(
                            final_scores[
                                index
                            ]
                        ),
                        4,
                    ),
                }
            )

        return results

    # ========================================================
    # PUBLIC RECOMMENDATION METHOD
    # ========================================================

    def recommend(
        self,
        skin_tone="Honey",
        occasion="Everyday",
        outfit_type="Kurti & Leggings",
        style="Casual",
        top_k=5,
    ):

        source = self._select_source(
            outfit_type
        )

        print(
            f"Recommendation source: "
            f"{source}"
        )

        if source == "deepfashion":

            recommendations = (
                self._recommend_deepfashion(
                    skin_tone=skin_tone,
                    occasion=occasion,
                    outfit_type=outfit_type,
                    style=style,
                    top_k=top_k,
                )
            )

        else:

            recommendations = (
                self._recommend_meesho(
                    skin_tone=skin_tone,
                    occasion=occasion,
                    outfit_type=outfit_type,
                    style=style,
                    top_k=top_k,
                )
            )

        return {
            "source": source,
            "recommendations": recommendations,
        }