import '../services/recommendation_api.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;

  final String? imageUrl;

  final String category;
  final String outfitType;
  final String color;
  final String occasion;
  final String style;

  final List<String> compatibleSkinTones;

  final String source;
  final List<String> attributes;
  final double score;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.imageUrl,
    required this.category,
    required this.outfitType,
    required this.color,
    required this.occasion,
    required this.style,
    required this.compatibleSkinTones,
    this.source = '',
    this.attributes = const [],
    this.score = 0.0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawAttributes = json['attributes'];

    List<String> parsedAttributes = [];

    if (rawAttributes is List) {
      parsedAttributes = rawAttributes
          .map((value) => value.toString())
          .where((value) => value.isNotEmpty)
          .toList();
    } else if (rawAttributes is Map) {
      parsedAttributes = rawAttributes.values
          .map((value) => value.toString())
          .where((value) => value.isNotEmpty)
          .toList();
    }

    final category = json['category']?.toString() ?? '';

    final source = json['source']?.toString() ?? '';

    String? imageUrl =
        json['imageUrl']?.toString() ??
            json['image_url']?.toString();

    // Convert DeepFashion relative image path
    // into a complete URL.
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl.startsWith('/')) {
      imageUrl = '${RecommendationApi.baseUrl}$imageUrl';
    }

    return Product(
      id: json['id']?.toString() ?? '',

      name: json['name']?.toString() ??
          _generateName(category, parsedAttributes),

      brand: json['brand']?.toString() ??
          source,

      price: (json['price'] as num?)?.toDouble() ?? 0.0,

      imageUrl: imageUrl,

      category: category,

      outfitType:
      json['outfitType']?.toString() ?? '',

      color:
      json['color']?.toString() ?? '',

      occasion:
      json['occasion']?.toString() ?? '',

      style:
      json['style']?.toString() ?? '',

      compatibleSkinTones:
      List<String>.from(
        json['compatibleSkinTones'] ?? [],
      ),

      source: source,

      attributes: parsedAttributes,

      score:
      (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static String _generateName(
      String category,
      List<String> attributes,
      ) {
    if (attributes.isNotEmpty) {
      final usefulAttributes =
      attributes.take(3).join(' ');

      return '$usefulAttributes $category'.trim();
    }

    return category.isNotEmpty
        ? category
        : 'Recommended Fashion Item';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'outfitType': outfitType,
      'color': color,
      'occasion': occasion,
      'style': style,
      'compatibleSkinTones':
      compatibleSkinTones,
      'source': source,
      'attributes': attributes,
      'score': score,
    };
  }
}