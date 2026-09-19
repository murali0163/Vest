import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: VestColors.card,
          border: Border.all(color: VestColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Fabric" block standing in for a product photo
            AspectRatio(
              aspectRatio: 0.82,
              child: Stack(
                children: [
                  Container(color: product.swatchColor.withValues(alpha: 0.85)),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: VestColors.ink.withValues(alpha: 0.85),
                      child: Text(
                        '${product.matchScore.round()}% match',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: VestColors.canvas,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Row(
                      children: product.colorOptions
                          .map((c) => Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: VestColors.canvas, width: 1.5),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}