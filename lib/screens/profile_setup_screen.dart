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
  static const totalSteps = 3;

  static const skinToneSwatches = <SkinTone, Color>{
    SkinTone.porcelain: Color(0xFFF3DCC9),
    SkinTone.warmBeige: Color(0xFFE3B98F),
    SkinTone.honey: Color(0xFFCC9760),
    SkinTone.caramel: Color(0xFFAD7444),
    SkinTone.umber: Color(0xFF7C4E2E),
    SkinTone.deepEbony: Color(0xFF4A2E1D),
  };

  void _next() {
    if (step < totalSteps - 1) {
      setState(() => step++);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(profile: profile)),
      );
    }
  }

  bool get _canProceed {
    switch (step) {
      case 0:
        return profile.skinTone != null;
      case 1:
        return profile.occasion != null;
      case 2:
        return profile.outfitType != null;
      default:
        return true;
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
          onPressed: () => setState(() => step--),
        ),
        title: Text('${step + 1} / $totalSteps',
            style: Theme.of(context).textTheme.labelLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // progress stitch-line
              Row(
                children: List.generate(totalSteps, (i) {
                  return Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.only(right: 4),
                      color: i <= step ? VestColors.ink : VestColors.line,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),
              Expanded(child: _buildStep(context)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canProceed ? _next : null,
                  child: Text(step == totalSteps - 1 ? 'See my picks' : 'Continue'),
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
      case 0:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What\'s your skin tone?', style: textTheme.displayMedium),
              const SizedBox(height: 8),
              Text(
                'This shapes the color palette we recommend — pick the closest '
                    'match to how your skin looks day-to-day (not under makeup).',
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
                    onTap: () => setState(() => profile.skinTone = e.key),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      case 1:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What\'s the occasion?', style: textTheme.displayMedium),
              const SizedBox(height: 8),
              Text('This decides what kind of outfits we show you next.',
                  style: textTheme.bodyMedium),
              const SizedBox(height: 28),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: occasionOptions.map((o) {
                  return SwatchChip(
                    label: o,
                    selected: profile.occasion == o,
                    onTap: () => setState(() {
                      profile.occasion = o;
                      // outfit type options depend on occasion — clear stale pick
                      profile.outfitType = null;
                    }),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      default:
        final options = outfitTypesByOccasion[profile.occasion] ?? [];
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pick your outfit type', style: textTheme.displayMedium),
              const SizedBox(height: 8),
              Text(
                'Styles suited to a ${profile.occasion?.toLowerCase() ?? "your"} occasion.',
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
                    onTap: () => setState(() => profile.outfitType = o),
                  );
                }).toList(),
              ),
            ],
          ),
        );
    }
  }
}