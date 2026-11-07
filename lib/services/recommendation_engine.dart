import '../data/mock_data.dart';
import '../models/product.dart';
import '../models/user_profile.dart';

class RecommendationResult {
  final StylingPreferences preferences;
  final List<Product> products;
  final bool hasExactOutfitMatch;

  const RecommendationResult({
    required this.preferences,
    required this.products,
    required this.hasExactOutfitMatch,
  });

  bool get hasOptionalPreferences =>
      preferences.ageRange != null ||
      preferences.gender != null ||
      preferences.skinTone != null;
}

class RecommendationEngine {
  static RecommendationResult recommend(
    StylingPreferences preferences, {
    Iterable<Product>? catalog,
  }) {
    // The sample catalog has no age, clothing-style, or skin-tone metadata.
    // Carry those preferences through without inferring a match from names/colors.
    final catalogProducts = (catalog ?? mockProducts).toList();
    final exactMatches = catalogProducts
        .where(
          (product) =>
              product.occasion == preferences.occasion &&
              product.outfitType == preferences.outfitType,
        )
        .toList();

    final selectedProducts = exactMatches.isNotEmpty
        ? exactMatches
        : catalogProducts
            .where((product) => product.occasion == preferences.occasion)
            .toList();

    selectedProducts.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    return RecommendationResult(
      preferences: preferences,
      products: List.unmodifiable(selectedProducts),
      hasExactOutfitMatch: exactMatches.isNotEmpty,
    );
  }
}
