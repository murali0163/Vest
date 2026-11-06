import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vest/data/mock_data.dart';
import 'package:vest/main.dart';
import 'package:vest/models/user_profile.dart';
import 'package:vest/services/recommendation_engine.dart';

Finder selectedOption(String label) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Semantics &&
        widget.properties.label == label &&
        widget.properties.selected == true,
  );
}

void main() {
  test('recommendations receive every styling preference', () {
    final preferences = StylingPreferences(
      ageRange: '25–34',
      gender: 'Womenswear',
      skinTone: SkinTone.warmBeige,
      occasion: 'Work',
      outfitType: 'Blazer Set',
    );

    final result = RecommendationEngine.recommend(preferences);

    expect(result.preferences, same(preferences));
    expect(result.preferences.ageRange, '25–34');
    expect(result.preferences.gender, 'Womenswear');
    expect(result.preferences.skinTone, SkinTone.warmBeige);
    expect(result.preferences.occasion, 'Work');
    expect(result.preferences.outfitType, 'Blazer Set');
    expect(result.products.map((product) => product.id), ['p1']);
    expect(result.hasExactOutfitMatch, isTrue);
    expect(result.hasOptionalPreferences, isTrue);
  });

  testWidgets('welcome layout fits the supported viewport widths',
      (tester) async {
    for (final width in [320.0, 375.0, 430.0, 768.0, 1024.0]) {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(const VestApp());
      await tester.pumpAndSettle();

      expect(find.text('Build my style profile'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'Viewport width: $width');
    }

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('five-step flow preserves all selections through product details',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const VestApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Build my style profile'));
    await tester.tap(find.text('Build my style profile'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 5'), findsOneWidget);
    expect(find.text('What’s your age?'), findsOneWidget);
    await tester.tap(find.text('25–34'));
    await tester.pumpAndSettle();
    expect(selectedOption('25–34'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('2 / 5'), findsOneWidget);
    expect(find.text('What styles would you like to explore?'), findsOneWidget);
    await tester.tap(find.text('Womenswear'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('3 / 5'), findsOneWidget);
    expect(find.text('Which skin tone is closest to yours?'), findsOneWidget);
    await tester.tap(find.text('Warm Beige'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('4 / 5'), findsOneWidget);
    expect(find.text('What’s the occasion?'), findsOneWidget);
    await tester.tap(find.text('Work'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('5 / 5'), findsOneWidget);
    expect(find.text('What would you like to wear?'), findsOneWidget);
    await tester.tap(find.text('Blazer Set'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('See my picks'));
    await tester.pumpAndSettle();

    expect(find.text('Looks for Work'), findsOneWidget);
    expect(find.text('Work · Blazer Set · Warm Beige'), findsOneWidget);
    expect(find.textContaining('not tagged to match those preferences yet'),
        findsOneWidget);
    expect(find.text('Tailored Blazer Set'), findsOneWidget);
    expect(find.textContaining('% match'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.drag(
      find.byType(CustomScrollView),
      const Offset(0, -600),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('View details'));
    await tester.tap(find.text('View details'));
    await tester.pumpAndSettle();
    expect(find.text('Why it’s in your edit'), findsOneWidget);
    expect(find.textContaining('occasion and blazer set outfit preference'),
        findsOneWidget);
    expect(find.text('PHOTO UNAVAILABLE'), findsOneWidget);
    await tester.ensureVisible(find.text('Save this piece'));
    await tester.tap(find.text('Save this piece'));
    await tester.pumpAndSettle();
    expect(find.text('Saved to your edit'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove from saved items'), findsOneWidget);
    await tester.drag(
      find.byType(CustomScrollView),
      const Offset(0, 700),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit preferences'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 5'), findsOneWidget);
    expect(selectedOption('25–34'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(selectedOption('Womenswear'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('optional profile steps can be skipped', (tester) async {
    tester.view.physicalSize = const Size(375, 700);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const VestApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Build my style profile'));
    await tester.tap(find.text('Build my style profile'));
    await tester.pumpAndSettle();
    for (var step = 0; step < 3; step++) {
      expect(find.text('Skip for now'), findsOneWidget);
      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle();
    }

    expect(find.text('What’s the occasion?'), findsOneWidget);
    await tester.tap(find.text('Everyday'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('T-Shirt & Jeans'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('See my picks'));
    await tester.pumpAndSettle();

    expect(find.text('Looks for Everyday'), findsOneWidget);
    expect(
      find.text('No T-Shirt & Jeans pieces in the catalog yet. '
          'Showing what’s available for this occasion.'),
      findsOneWidget,
    );
    expect(find.text('Cotton Kurti & Leggings'), findsOneWidget);
    expect(find.textContaining('not tagged to match those preferences yet'),
        findsNothing);
    expect(tester.takeException(), isNull);

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  test('a missing exact outfit match falls back to the selected occasion', () {
    final result = RecommendationEngine.recommend(
      StylingPreferences(occasion: 'Everyday', outfitType: 'T-Shirt & Jeans'),
      catalog: mockProducts,
    );

    expect(result.hasExactOutfitMatch, isFalse);
    expect(result.products.map((product) => product.outfitType),
        ['Kurti & Leggings']);
  });
}
