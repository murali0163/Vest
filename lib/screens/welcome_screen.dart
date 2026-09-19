import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'profile_setup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Text('V E S T', style: textTheme.labelLarge?.copyWith(letterSpacing: 4)),
              const SizedBox(height: 18),
              Text(
                'Clothes that already\nknow your palette.',
                style: textTheme.displayLarge,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 280,
                child: Text(
                  'Tell us your skin tone, style, and the occasion — Vest '
                      'narrows thousands of pieces down to the ones actually '
                      'worth trying on.',
                  style: textTheme.bodyLarge?.copyWith(color: VestColors.inkFaint),
                ),
              ),
              const Spacer(flex: 3),
              // Signature: stacked swatch strip, like fanned fabric samples
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    _swatch(VestColors.blush),
                    _swatch(VestColors.moss),
                    _swatch(VestColors.mustard),
                    _swatch(VestColors.ink),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
                    );
                  },
                  child: const Text('Build my style profile'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _swatch(Color color) => Expanded(
    child: Container(
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(color: color),
    ),
  );
}