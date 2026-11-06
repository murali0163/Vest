import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import 'product_artwork.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final double imageHeight;
  final bool isSaved;
  final VoidCallback onToggleSaved;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.imageHeight,
    required this.isSaved,
    required this.onToggleSaved,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: VestColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: VestColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ProductArtwork(product: product),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      tooltip:
                          isSaved ? 'Remove from saved items' : 'Save item',
                      onPressed: onToggleSaved,
                      style: IconButton.styleFrom(
                        backgroundColor:
                            VestColors.card.withValues(alpha: 0.94),
                        foregroundColor: VestColors.ink,
                        minimumSize: const Size(48, 48),
                      ),
                      icon: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(letterSpacing: 0.7),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: textTheme.titleMedium?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  _ColorOptions(colors: product.colorOptions),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: TextButton(
                      onPressed: onTap,
                      style: TextButton.styleFrom(
                        foregroundColor: VestColors.ink,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      child: const Text('View details'),
                    ),
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

class _ColorOptions extends StatelessWidget {
  final List<Color> colors;

  const _ColorOptions({required this.colors});

  @override
  Widget build(BuildContext context) {
    final visibleColors = colors.take(3).toList();
    return Semantics(
      label: '${colors.length} available color variants',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: visibleColors
            .map(
              (color) => Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: VestColors.line),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
