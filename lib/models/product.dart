import 'package:flutter/material.dart';

import '../services/recommendation_api.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final Color swatchColor;
  final List<Color> colorOptions;
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
  final double matchScore;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.swatchColor = const Color(0xFFD5D0C6),
    this.colorOptions = const [],
    this.imageUrl,
    this.category = '',
    this.outfitType = '',
    this.color = '',
    this.occasion = '',
    this.style = '',
    this.compatibleSkinTones = const [],
    this.source = '',
    this.attributes = const [],
    this.score = 0,
    this.matchScore = 0,
  });

  List<Color> get availableColors =>
      colorOptions.isEmpty ? [swatchColor] : colorOptions;

  factory Product.fromJson(Map<String, dynamic> json) {
    final category = _stringValue(json['category']);
    final source = _stringValue(json['source']);
    final attributes = _stringList(json['attributes']);
    final rawImageUrl = json['imageUrl'] ?? json['image_url'];
    var imageUrl = rawImageUrl?.toString();
    if (imageUrl != null && imageUrl.startsWith('/')) {
      imageUrl = '${RecommendationApi.baseUrl}$imageUrl';
    }

    final color = _stringValue(json['color']);
    final swatchColor = _parseColor(json['swatchColor'] ?? color);
    final rawColorOptions = json['colorOptions'] ?? json['color_options'];
    final colorOptions = rawColorOptions is List
        ? rawColorOptions.map(_parseColor).toList()
        : <Color>[];

    return Product(
      id: _stringValue(json['id']),
      name: _stringValue(
        json['name'],
        fallback: attributes.isEmpty
            ? category.isEmpty
                ? 'Recommended Fashion Item'
                : category
            : '${attributes.take(3).join(' ')} $category'.trim(),
      ),
      brand: _stringValue(json['brand'], fallback: source),
      price: _numberValue(json['price']),
      swatchColor: swatchColor,
      colorOptions: colorOptions,
      imageUrl: imageUrl,
      category: category,
      outfitType: _stringValue(json['outfitType'] ?? json['outfit_type']),
      color: color,
      occasion: _stringValue(json['occasion']),
      style: _stringValue(json['style']),
      compatibleSkinTones: _stringList(
        json['compatibleSkinTones'] ?? json['compatible_skin_tones'],
      ),
      source: source,
      attributes: attributes,
      score: _numberValue(json['score']),
      matchScore: _numberValue(json['matchScore'] ?? json['match_score']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brand': brand,
        'price': price,
        'swatchColor': swatchColor.toARGB32(),
        'colorOptions': colorOptions.map((color) => color.toARGB32()).toList(),
        'imageUrl': imageUrl,
        'category': category,
        'outfitType': outfitType,
        'color': color,
        'occasion': occasion,
        'style': style,
        'compatibleSkinTones': compatibleSkinTones,
        'source': source,
        'attributes': attributes,
        'score': score,
        'matchScore': matchScore,
      };

  static String _stringValue(Object? value, {String fallback = ''}) =>
      value == null || value.toString().isEmpty ? fallback : value.toString();

  static double _numberValue(Object? value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;

  static List<String> _stringList(Object? value) {
    bool isPresent(Object? item) =>
        item != null && item.toString().trim().isNotEmpty && item != 'null';

    if (value is List) {
      return value
          .where(isPresent)
          .map((item) => item.toString().trim())
          .toList();
    }
    if (value is Map) {
      return value.values
          .where(isPresent)
          .map((item) => item.toString().trim())
          .toList();
    }
    if (value is String && value.isNotEmpty) {
      return value
          .split(RegExp(r'[,|]'))
          .map((item) => item.trim())
          .where(isPresent)
          .toList();
    }
    return const [];
  }

  static Color _parseColor(Object? value) {
    if (value is int) return Color(value);
    final text = value?.toString().trim().toLowerCase() ?? '';
    final hex = text.replaceFirst('#', '').replaceFirst('0x', '');
    if (RegExp(r'^[0-9a-f]{6}$').hasMatch(hex)) {
      return Color(int.parse('ff$hex', radix: 16));
    }
    if (RegExp(r'^[0-9a-f]{8}$').hasMatch(hex)) {
      return Color(int.parse(hex, radix: 16));
    }
    const namedColors = {
      'black': Color(0xFF23262B),
      'blue': Color(0xFF426A8C),
      'emerald': Color(0xFF2F4A3C),
      'grey': Color(0xFF6B6C6E),
      'gray': Color(0xFF6B6C6E),
      'ivory': Color(0xFFEDEAE3),
      'maroon': Color(0xFF7A2A2E),
      'mustard': Color(0xFFD4A85A),
      'ochre': Color(0xFFD4A85A),
      'olive': Color(0xFF6B7A5E),
      'rose': Color(0xFFC97B84),
      'white': Color(0xFFEDEAE3),
    };
    return namedColors[text] ?? const Color(0xFFD5D0C6);
  }
}
