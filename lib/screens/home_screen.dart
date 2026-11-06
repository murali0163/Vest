import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/user_profile.dart';
import '../services/recommendation_api.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile profile;

  const HomeScreen({
    super.key,
    required this.profile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> recommendations = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await RecommendationApi.getRecommendations(
        profile: widget.profile,
        topK: 10,
      );

      if (!mounted) return;

      setState(() {
        recommendations = results;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Style Picks'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadRecommendations,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Finding outfits for you...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 100),
          const Icon(
            Icons.cloud_off,
            size: 64,
          ),
          const SizedBox(height: 20),
          const Text(
            'Could not load recommendations',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadRecommendations,
            child: const Text('Try Again'),
          ),
        ],
      );
    }

    if (recommendations.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: const [
          SizedBox(height: 120),
          Icon(
            Icons.checkroom_outlined,
            size: 64,
          ),
          SizedBox(height: 20),
          Text(
            'No recommendations found.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        _buildProfileSummary(),

        const SizedBox(height: 24),

        const Text(
          'Recommended for You',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          '${recommendations.length} recommendations based on your preferences',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 20),

        ...recommendations.map(
              (product) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ProductCard(
              product: product,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(
                      product: product,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Style Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _profileChip(
                widget.profile.skinTone?.label ?? '',
              ),
              _profileChip(
                widget.profile.occasion ?? '',
              ),
              _profileChip(
                widget.profile.outfitType ?? '',
              ),
              _profileChip(
                widget.profile.style ?? '',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileChip(String text) {
    return Chip(
      label: Text(text),
    );
  }
}