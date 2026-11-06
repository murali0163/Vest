import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/product_artwork.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final StylingPreferences preferences;
  final bool isSaved;
  final VoidCallback onToggleSaved;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.preferences,
    required this.isSaved,
    required this.onToggleSaved,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedColorIndex = 0;
  late bool isSaved = widget.isSaved;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final preferences = widget.preferences;
    final textTheme = Theme.of(context).textTheme;
    final exactMatch = product.occasion == preferences.occasion &&
        product.outfitType == preferences.outfitType;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.brand.toUpperCase(),
          style: textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
        ),
        actions: [
          IconButton(
            tooltip: isSaved ? 'Remove from saved items' : 'Save item',
            onPressed: () {
              setState(() => isSaved = !isSaved);
              widget.onToggleSaved();
            },
            icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final contentWidth = math.min(constraints.maxWidth - 40, 920.0);
          final imageSize = math.min(contentWidth, 520.0);

          return SingleChildScrollView(
            primary: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: imageSize,
                          height: imageSize,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ProductArtwork(product: product),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        product.brand.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          letterSpacing: 1,
                          color: VestColors.moss,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(product.name, style: textTheme.displayMedium),
                      const SizedBox(height: 10),
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1, color: VestColors.line),
                      const SizedBox(height: 20),
                      Text('Why it’s in your edit',
                          style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        exactMatch
                            ? 'Selected for your ${product.occasion.toLowerCase()} '
                                'occasion and ${product.outfitType.toLowerCase()} '
                                'outfit preference.'
                            : 'An available ${product.outfitType.toLowerCase()} '
                                'for ${product.occasion.toLowerCase()}. The current '
                                'catalog doesn’t have an exact match for your '
                                'selected outfit type.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: VestColors.inkFaint,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Available colors', style: textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children:
                            List.generate(product.colorOptions.length, (index) {
                          final selected = selectedColorIndex == index;
                          return Semantics(
                            button: true,
                            selected: selected,
                            label: 'Color option ${index + 1}',
                            child: InkWell(
                              onTap: () =>
                                  setState(() => selectedColorIndex = index),
                              borderRadius: BorderRadius.circular(28),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: product.colorOptions[index],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected
                                        ? VestColors.ink
                                        : VestColors.line,
                                    width: selected ? 2 : 1,
                                  ),
                                ),
                                child: selected
                                    ? const Icon(
                                        Icons.check,
                                        color: VestColors.ink,
                                        size: 20,
                                      )
                                    : null,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() => isSaved = !isSaved);
                          widget.onToggleSaved();
                        },
                        icon: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                        ),
                        label: Text(
                            isSaved ? 'Saved to your edit' : 'Save this piece'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: VestColors.ink,
                          minimumSize: const Size.fromHeight(52),
                          side: const BorderSide(color: VestColors.line),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
