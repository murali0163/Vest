import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user_profile.dart';

class RecommendationApi {
  // For Flutter running on Windows/Desktop:
  static const String baseUrl = 'http://127.0.0.1:8000';

  // If you later run Flutter on an Android emulator,
  // change the above to:
  // static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<List<Product>> getRecommendations({
    required UserProfile profile,
    int topK = 10,
  }) async {
    final url = Uri.parse('$baseUrl/recommend');

    final body = {
      'skin_tone': profile.skinTone?.label ?? 'Honey',
      'occasion': profile.occasion ?? 'Everyday',
      'outfit_type': profile.outfitType ?? 'Casual Dress',
      'style': profile.style ?? 'Casual',
      'top_k': topK,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    print("STATUS: ${response.statusCode}");
    print("RESPONSE: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        'Recommendation API failed: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    final recommendations =
        data['recommendations'] as List<dynamic>? ?? [];

    return recommendations
        .map(
          (item) => Product.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }
}