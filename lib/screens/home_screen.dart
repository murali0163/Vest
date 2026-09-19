import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/product.dart';
import '../models/user_profile.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserProfile profile;
  const HomeScreen({super.key, required this.profile});

  List<Product> get _matches {
    final exact = mockProducts.where((p) =>
    p.occasion == profile.occasion && p.outfitType == profile.outfitType);
    if (exact.isNotEmpty) {
      return exact.toList()..sort((a, b) => b.matchScore.compareTo(a.matchScore));
    }
    // fall back to just occasion match if the exact outfit type has no items yet
    return mockProducts.where((p) => p.occasion == profile.occasion).toList()
      ..sort((a, b) => b.matchScore.compareTo(a.matchScore));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final results = _matches;

    return Scaffold(
      appBar: AppBar(
        title: Text('V E S T', style: textTheme.labelLarge?.copyWith(letterSpacing: 3)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(
                '${profile.outfitType ?? "Picks"} for '
                    '${profile.skinTone?.label.toLowerCase() ?? "you"} · '
                    '${profile.occasion ?? ""}',
                style: textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? Center(
                child: Text(
                  'No matches yet for this combination.',
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemCount: results.length,
                itemBuilder: (context, i) {
                  final p = results[i];
                  return ProductCard(
                    product: p,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: p),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}