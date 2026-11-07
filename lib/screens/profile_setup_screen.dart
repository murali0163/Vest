import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/swatch_chip.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final StylingPreferences? initialPreferences;

  const ProfileSetupScreen({super.key, this.initialPreferences});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late final StylingPreferences preferences =
      widget.initialPreferences ?? StylingPreferences();
  int step = 0;
  static const totalSteps = 5;

  static const ageRanges = [
    'Under 18',
    '18–24',
    '25–34',
    '35–44',
    '45–54',
    '55+',
  ];

  static const clothingStyles = ['Womenswear', 'Menswear', 'All styles'];

  static const skinToneSwatches = <SkinTone, Color>{
    SkinTone.porcelain: Color(0xFFF3DCC9),
    SkinTone.warmBeige: Color(0xFFE3B98F),
    SkinTone.honey: Color(0xFFCC9760),
    SkinTone.caramel: Color(0xFFAD7444),
    SkinTone.umber: Color(0xFF7C4E2E),
    SkinTone.deepEbony: Color(0xFF4A2E1D),
  };

  static const occasionIcons = <String, IconData>{
    'Everyday': Icons.wb_sunny_outlined,
    'Work': Icons.work_outline,
    'Date Night': Icons.nightlight_outlined,
    'Festival': Icons.local_florist_outlined,
    'Wedding': Icons.favorite_border,
  };

  bool get _isOptionalStep => step < 3;

  bool get _hasOptionalSelection {
    switch (step) {
      case 0:
        return preferences.ageRange != null;
      case 1:
        return preferences.gender != null;
      case 2:
        return preferences.skinTone != null;
      default:
        return false;
    }
  }

  bool get _canProceed {
    if (step == 3) return preferences.occasion != null;
    if (step == 4) return preferences.outfitType != null;
    return true;
  }

  void _next() {
    if (step < totalSteps - 1) {
      setState(() => step++);
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeScreen(preferences: preferences),
      ),
    );
  }

  void _back() {
    if (step > 0) {
      setState(() => step--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Go back',
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
        title: Text(
          'STYLE PROFILE',
          style: textTheme.labelLarge?.copyWith(letterSpacing: 1.4),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                '${step + 1} / $totalSteps',
                style: textTheme.labelSmall,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
            child: Semantics(
              label: 'Step ${step + 1} of $totalSteps',
              child: Row(
                children: List.generate(totalSteps, (index) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      height: 3,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: index <= step ? VestColors.ink : VestColors.line,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  key: ValueKey('profile-step-$step'),
                  primary: false,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                          child: _buildStep(
                            context,
                            math.min(constraints.maxWidth - 48, 672),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: VestColors.canvas,
            border: Border(top: BorderSide(color: VestColors.line)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Align(
              alignment: Alignment.center,
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 672),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canProceed ? _next : null,
                    child: Text(
                      step == 4
                          ? 'See my picks'
                          : _isOptionalStep && !_hasOptionalSelection
                              ? 'Skip for now'
                              : 'Continue',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, double contentWidth) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '0${step + 1}  /  0$totalSteps',
          style: textTheme.labelSmall?.copyWith(
            color: VestColors.moss,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _titleForStep,
          style: textTheme.displayMedium?.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 10),
        Text(
          _descriptionForStep,
          style: textTheme.bodyLarge?.copyWith(
            color: VestColors.inkFaint,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 24),
        if (step == 0)
          _buildChoiceOptions(
            options: ageRanges,
            selected: preferences.ageRange,
            columns: 2,
            width: contentWidth,
            onSelected: (value) => setState(() => preferences.ageRange = value),
          )
        else if (step == 1)
          _buildChoiceOptions(
            options: clothingStyles,
            selected: preferences.gender,
            columns: 2,
            width: contentWidth,
            onSelected: (value) => setState(() => preferences.gender = value),
          )
        else if (step == 2)
          _buildSkinToneOptions(contentWidth)
        else if (step == 3)
          _buildChoiceOptions(
            options: occasionOptions,
            selected: preferences.occasion,
            columns: 2,
            width: contentWidth,
            iconFor: (value) => occasionIcons[value],
            onSelected: (value) {
              setState(() {
                preferences.occasion = value;
                preferences.outfitType = null;
              });
            },
          )
        else
          _buildChoiceOptions(
            options: outfitTypesByOccasion[preferences.occasion] ?? const [],
            selected: preferences.outfitType,
            columns: 2,
            width: contentWidth,
            onSelected: (value) =>
                setState(() => preferences.outfitType = value),
          ),
      ],
    );
  }

  Widget _buildSkinToneOptions(double width) {
    const columns = 3;
    const spacing = 8.0;
    final tileWidth = (width - spacing * (columns - 1)) / columns;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: skinToneSwatches.entries.map((entry) {
        return SizedBox(
          width: tileWidth,
          height: 100,
          child: ToneSwatch(
            color: entry.value,
            label: entry.key.label,
            selected: preferences.skinTone == entry.key,
            onTap: () => setState(() => preferences.skinTone = entry.key),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChoiceOptions({
    required List<String> options,
    required String? selected,
    required int columns,
    required double width,
    required ValueChanged<String> onSelected,
    IconData? Function(String value)? iconFor,
  }) {
    const spacing = 10.0;
    final tileWidth = (width - spacing * (columns - 1)) / columns;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: options.map((option) {
        return SizedBox(
          width: tileWidth,
          height: 84,
          child: SwatchChip(
            label: option,
            icon: iconFor?.call(option),
            selected: selected == option,
            onTap: () => onSelected(option),
          ),
        );
      }).toList(),
    );
  }

  String get _titleForStep {
    switch (step) {
      case 0:
        return 'What’s your age?';
      case 1:
        return 'What styles would you like to explore?';
      case 2:
        return 'Which skin tone is closest to yours?';
      case 3:
        return 'What’s the occasion?';
      default:
        return 'What would you like to wear?';
    }
  }

  String get _descriptionForStep {
    switch (step) {
      case 0:
        return 'Choose a range or skip. We don’t ask for a date of birth, and '
            'age never limits what you can wear.';
      case 1:
        return 'Choose a clothing section, not a gender identity. This is '
            'optional and can be changed anytime.';
      case 2:
        return 'An optional color preference—not a rule about what colors you '
            'can wear.';
      case 3:
        return 'Start with where you’re headed. We’ll keep the next choices '
            'focused on this moment.';
      default:
        return 'A few silhouettes for '
            '${preferences.occasion?.toLowerCase() ?? 'your'} '
            'occasion.';
    }
  }
}
