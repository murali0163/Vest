import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final Color swatchColor;
  final List<Color> colorOptions;
  final String occasion;
  final String outfitType;
  final double matchScore; // 0-100, how well it fits the user profile

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.swatchColor,
    required this.colorOptions,
    required this.occasion,
    required this.outfitType,
    required this.matchScore,
  });
}