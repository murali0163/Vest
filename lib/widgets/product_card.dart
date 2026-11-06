import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  Color _getColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'olive':
        return const Color(0xFF6B7A5E);

      case 'ochre':
        return const Color(0xFFD4A85A);

      case 'rose':
        return const Color(0xFFC97B84);

      case 'emerald':
        return const Color(0xFF2F4A3C);

      case 'ivory':
        return const Color(0xFFEDEAE3);

      case 'maroon':
        return const Color(0xFF7A2A2E);

      case 'grey':
        return const Color(0xFF6B6C6E);

      case 'black':
        return const Color(0xFF23262B);

      case 'mustard':
        return const Color(0xFFD4A85A);

      default:
        return VestColors.line;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productColor = _getColor(product.color);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: VestColors.line,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ----------------------------------------------------------
            // PRODUCT IMAGE
            // ----------------------------------------------------------
            SizedBox(
              height: 420,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Container(
                  color: const Color(0xFFF7F5F1),
                  child: product.imageUrl != null &&
                      product.imageUrl!.isNotEmpty
                      ? Image.network(
                    product.imageUrl!,
                    width: double.infinity,
                    height: double.infinity,

                    // IMPORTANT:
                    // Shows the complete clothing image.
                    fit: BoxFit.contain,

                    // Better image rendering.
                    filterQuality: FilterQuality.high,

                    // Prevents unnecessary visual flashing
                    // when the image is loaded.
                    gaplessPlayback: true,

                    loadingBuilder:
                        (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },

                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Container(
                        color: productColor.withOpacity(0.25),
                        child: const Center(
                          child: Icon(
                            Icons.checkroom_outlined,
                            size: 56,
                          ),
                        ),
                      );
                    },
                  )
                      : Container(
                    color: productColor.withOpacity(0.25),
                    child: const Center(
                      child: Icon(
                        Icons.checkroom_outlined,
                        size: 56,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ----------------------------------------------------------
            // PRODUCT INFORMATION
            // ----------------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    product.brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 8),

                  if (product.source.toLowerCase() ==
                      'deepfashion') ...[
                    Text(
                      'DeepFashion',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      product.attributes.take(3).join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ] else ...[
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${product.color} • ${product.style}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}