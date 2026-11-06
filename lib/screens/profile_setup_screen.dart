import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/swatch_chip.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final profile = UserProfile();

  int step = 0;

  static const totalSteps = 5;

  static const skinToneSwatches = <SkinTone, Color>{
    SkinTone.porcelain: Color(0xFFF3DCC9),
    SkinTone.warmBeige: Color(0xFFE3B98F),
    SkinTone.honey: Color(0xFFCC9760),
    SkinTone.caramel: Color(0xFFAD7444),
    SkinTone.umber: Color(0xFF7C4E2E),
    SkinTone.deepEbony: Color(0xFF4A2E1D),
  };

  static const styleOptions = [
    'Casual',
    'Formal',
    'Traditional',
    'Streetwear',
    'Minimal',
    'Trendy',
  ];

  void _next() {
    if (step < totalSteps - 1) {
      setState(() => step++);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(profile: profile),
        ),
      );
    }
  }

  bool get _canProceed {
    switch (step) {
      case 0:
        return true;

      case 1:
        return profile.skinTone != null;

      case 2:
        return profile.occasion != null;

      case 3:
        return profile.outfitType != null;

      case 4:
        return profile.style != null;

      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: step == 0
            ? const BackButton()
            : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() => step--);
          },
        ),
        title: Text(
          '${step + 1} / $totalSteps',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress line
              Row(
                children: List.generate(
                  totalSteps,
                      (i) {
                    return Expanded(
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.only(right: 4),
                        color: i <= step
                            ? VestColors.ink
                            : VestColors.line,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              Expanded(
                child: _buildStep(context),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canProceed ? _next : null,
                  child: Text(
                    step == totalSteps - 1
                        ? 'See my picks'
                        : 'Continue',
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    switch (step) {
    // STEP 1 - STYLE PROFILE
      case 0:
        return Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Let\'s build your style profile',
                  style: textTheme.displayMedium,
                ),

                const SizedBox(height: 12),

                Text(
                  'Tell us a little about your fashion preferences '
                      'and we\'ll create personalized outfit recommendations '
                      'just for you.',
                  style: textTheme.bodyMedium,
                ),

                const SizedBox(height: 32),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: VestColors.line.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.checkroom_outlined,
                        size: 64,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Your preferences matter',
                        style: textTheme.titleLarge,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'We will use your skin tone, occasion, '
                            'outfit preference and personal style '
                            'to personalize your recommendations.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    // STEP 2 - SKIN TONE
      case 1:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What\'s your skin tone?',
                style: textTheme.displayMedium,
              ),

              const SizedBox(height: 8),

              Text(
                'This helps us recommend colors that complement '
                    'your skin tone.',
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 28),

              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: skinToneSwatches.entries.map((e) {
                  return ToneSwatch(
                    color: e.value,
                    label: e.key.label,
                    selected: profile.skinTone == e.key,
                    onTap: () {
                      setState(() {
                        profile.skinTone = e.key;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );

    // STEP 3 - OCCASION
      case 2:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What\'s the occasion?',
                style: textTheme.displayMedium,
              ),

              const SizedBox(height: 8),

              Text(
                'Choose the occasion you are dressing for.',
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 28),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: occasionOptions.map((o) {
                  return SwatchChip(
                    label: o,
                    selected: profile.occasion == o,
                    onTap: () {
                      setState(() {
                        profile.occasion = o;

                        // Outfit types depend on occasion.
                        profile.outfitType = null;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );

    // STEP 4 - OUTFIT TYPE
      case 3:
        final options =
            outfitTypesByOccasion[profile.occasion] ?? [];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pick your outfit type',
                style: textTheme.displayMedium,
              ),

              const SizedBox(height: 8),

              Text(
                'Choose the type of outfit you want to explore.',
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 28),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: options.map((o) {
                  return SwatchChip(
                    label: o,
                    selected: profile.outfitType == o,
                    onTap: () {
                      setState(() {
                        profile.outfitType = o;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );

    // STEP 5 - PERSONAL STYLE
      case 4:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What\'s your personal style?',
                style: textTheme.displayMedium,
              ),

              const SizedBox(height: 8),

              Text(
                'Choose the style that best matches your personality.',
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 28),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: styleOptions.map((style) {
                  return SwatchChip(
                    label: style,
                    selected: profile.style == style,
                    onTap: () {
                      setState(() {
                        profile.style = style;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}