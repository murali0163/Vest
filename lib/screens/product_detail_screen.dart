import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================================
            // PRODUCT IMAGE
            // ==========================================================
            Container(
              width: double.infinity,
              height: 560,
              color: const Color(0xFFF7F5F1),
              child: product.imageUrl != null &&
                  product.imageUrl!.isNotEmpty
                  ? Image.network(
                product.imageUrl!,
                width: double.infinity,
                height: double.infinity,

                // IMPORTANT:
                // Shows the complete image instead of cropping it.
                fit: BoxFit.contain,

                filterQuality: FilterQuality.high,

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
                        size: 72,
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
                    size: 72,
                  ),
                ),
              ),
            ),

            // ==========================================================
            // PRODUCT INFORMATION
            // ==========================================================
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.brand,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 16),

                  // DeepFashion doesn't have price information.
                  if (product.source.toLowerCase() ==
                      'deepfashion')
                    Text(
                      'DeepFashion',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall,
                    )
                  else
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall,
                    ),

                  const SizedBox(height: 24),

                  const Divider(),

                  const SizedBox(height: 20),

                  _InfoRow(
                    label: 'Category',
                    value: product.category,
                  ),

                  _InfoRow(
                    label: 'Outfit Type',
                    value: product.outfitType.isNotEmpty
                        ? product.outfitType
                        : 'Not specified',
                  ),

                  _InfoRow(
                    label: 'Color',
                    value: product.color.isNotEmpty
                        ? product.color
                        : 'Not specified',
                  ),

                  _InfoRow(
                    label: 'Occasion',
                    value: product.occasion.isNotEmpty
                        ? product.occasion
                        : 'Not specified',
                  ),

                  _InfoRow(
                    label: 'Style',
                    value: product.style.isNotEmpty
                        ? product.style
                        : 'Not specified',
                  ),

                  // ==================================================
                  // DEEPFASHION ATTRIBUTES
                  // ==================================================
                  if (product.attributes.isNotEmpty) ...[
                    const SizedBox(height: 20),

                    Text(
                      'Fashion Attributes',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.attributes
                          .map(
                            (attribute) => Chip(
                          label: Text(attribute),
                        ),
                      )
                          .toList(),
                    ),
                  ],

                  // ==================================================
                  // SKIN TONES
                  // ==================================================
                  if (product.compatibleSkinTones.isNotEmpty) ...[
                    const SizedBox(height: 20),

                    Text(
                      'Suitable Skin Tones',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.compatibleSkinTones
                          .map(
                            (tone) => Chip(
                          label: Text(tone),
                        ),
                      )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}