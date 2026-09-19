import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: VestColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: Container(color: product.swatchColor.withValues(alpha: 0.85)),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.brand.toUpperCase(),
                                  style: textTheme.labelSmall),
                              const SizedBox(height: 4),
                              Text(product.name, style: textTheme.displayMedium),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          color: VestColors.ink,
                          child: Text(
                            '${product.matchScore.round()}% match',
                            style: textTheme.labelSmall?.copyWith(color: VestColors.canvas),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('₹${product.price.toStringAsFixed(0)}',
                        style: textTheme.headlineSmall),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text('Why we picked this', style: textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'A ${product.outfitType.toLowerCase()} suited to '
                          '${product.occasion.toLowerCase()} occasions, matched to your '
                          'skin tone palette.',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    Text('Available colors', style: textTheme.titleMedium),
                    const SizedBox(height: 10),
                    Row(
                      children: product.colorOptions
                          .map((c) => Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(color: VestColors.line),
                        ),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Save to wardrobe'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}