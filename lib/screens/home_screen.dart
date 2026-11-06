import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/user_profile.dart';
import '../services/recommendation_api.dart';
import '../services/recommendation_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'profile_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  final StylingPreferences preferences;

  const HomeScreen({super.key, required this.preferences});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> _savedProducts = {};
  List<Product>? _apiProducts;
  bool _apiUnavailable = false;

  StylingPreferences get preferences => widget.preferences;

  @override
  void initState() {
    super.initState();
    _loadApiRecommendations();
  }

  Future<void> _loadApiRecommendations() async {
    try {
      final products = await RecommendationApi.getRecommendations(
        profile: preferences,
        topK: 10,
      );
      if (!mounted) return;
      setState(() {
        _apiProducts = products;
        _apiUnavailable = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _apiUnavailable = true);
    }
  }

  void _editPreferences() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ProfileSetupScreen(initialPreferences: preferences),
      ),
    );
  }

  void _toggleSaved(Product product) {
    setState(() {
      if (!_savedProducts.add(product.id)) {
        _savedProducts.remove(product.id);
      }
    });
  }

  void _openDetails(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product,
          preferences: preferences,
          isSaved: _savedProducts.contains(product.id),
          onToggleSaved: () => _toggleSaved(product),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localRecommendations = RecommendationEngine.recommend(preferences);
    final recommendations = _apiProducts == null
        ? localRecommendations
        : RecommendationResult(
            preferences: preferences,
            products: _apiProducts!,
            hasExactOutfitMatch: _apiProducts!.any(
              (product) =>
                  product.occasion == preferences.occasion &&
                  product.outfitType == preferences.outfitType,
            ),
          );
    final results = recommendations.products;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'V E S T',
          style: textTheme.labelLarge?.copyWith(letterSpacing: 3),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final contentWidth = math.min(constraints.maxWidth, 1320.0);
          final columns = contentWidth >= 1000
              ? 4
              : contentWidth >= 640
                  ? 3
                  : 2;
          final gridWidth = contentWidth - 40;
          final cardWidth = (gridWidth - (columns - 1) * 14) / columns;
          final imageHeight = math.min(cardWidth, 280.0);
          final cardHeight = imageHeight + 174;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: CustomScrollView(
                primary: false,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                      child: _ResultsHeader(
                        preferences: preferences,
                        count: results.length,
                        recommendations: recommendations,
                        onEdit: _editPreferences,
                        apiUnavailable: _apiUnavailable,
                        onRetry: _loadApiRecommendations,
                        usingLiveRecommendations: _apiProducts != null,
                      ),
                    ),
                  ),
                  if (results.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyResults(onEdit: _editPreferences),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      sliver: SliverGrid.builder(
                        itemCount: results.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                          mainAxisExtent: cardHeight,
                        ),
                        itemBuilder: (context, index) {
                          final product = results[index];
                          return ProductCard(
                            product: product,
                            imageHeight: imageHeight,
                            isSaved: _savedProducts.contains(product.id),
                            onTap: () => _openDetails(product),
                            onToggleSaved: () => _toggleSaved(product),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  final StylingPreferences preferences;
  final int count;
  final RecommendationResult recommendations;
  final VoidCallback onEdit;
  final bool apiUnavailable;
  final VoidCallback onRetry;
  final bool usingLiveRecommendations;

  const _ResultsHeader({
    required this.preferences,
    required this.count,
    required this.recommendations,
    required this.onEdit,
    required this.apiUnavailable,
    required this.onRetry,
    required this.usingLiveRecommendations,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final occasion = preferences.occasion ?? 'your occasion';
    final outfitType = preferences.outfitType ?? 'your style';
    final summary = [
      if (preferences.occasion != null) preferences.occasion!,
      if (preferences.outfitType != null) preferences.outfitType!,
      if (preferences.skinTone != null) preferences.skinTone!.label,
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'YOUR PERSONAL EDIT',
                style: textTheme.labelSmall?.copyWith(
                  color: VestColors.moss,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.tune, size: 18),
              label: const Text('Edit preferences'),
              style: TextButton.styleFrom(
                foregroundColor: VestColors.ink,
                minimumSize: const Size(44, 44),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Looks for $occasion', style: textTheme.displayMedium),
        const SizedBox(height: 8),
        Text(
          summary,
          style: textTheme.bodyLarge?.copyWith(color: VestColors.inkFaint),
        ),
        const SizedBox(height: 8),
        Text(
          recommendations.hasExactOutfitMatch
              ? 'Chosen for your occasion and outfit preference.'
              : 'No $outfitType pieces in the catalog yet. Showing what’s '
                  'available for this occasion.',
          style: textTheme.bodyMedium,
        ),
        if (apiUnavailable) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Live recommendations are unavailable; showing sample picks.',
                  style: textTheme.bodySmall,
                ),
              ),
              TextButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ],
        if (recommendations.hasOptionalPreferences) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: VestColors.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: VestColors.line),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline,
                    size: 18, color: VestColors.moss),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    usingLiveRecommendations
                        ? 'Age and clothing-section choices are saved for this '
                            'session. The live recommender uses skin tone, '
                            'occasion and outfit preference.'
                        : 'Age, clothing-style and skin-tone choices are saved '
                            'for this session, but the sample catalog is not '
                            'tagged to match those preferences yet.',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        const Divider(height: 1, color: VestColors.line),
        const SizedBox(height: 12),
        Text(
          '$count ${count == 1 ? 'piece' : 'pieces'} to explore',
          style: textTheme.labelLarge,
        ),
      ],
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final VoidCallback onEdit;

  const _EmptyResults({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.checkroom_outlined,
              size: 42,
              color: VestColors.moss,
            ),
            const SizedBox(height: 16),
            Text('Nothing in this edit just yet',
                style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Try another occasion or outfit type to explore the available pieces.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.tune),
              label: const Text('Edit preferences'),
            ),
          ],
        ),
      ),
    );
  }
}
