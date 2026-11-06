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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              key: const PageStorageKey('welcome'),
              primary: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'V E S T',
                                style: textTheme.labelLarge?.copyWith(
                                  letterSpacing: 3,
                                ),
                              ),
                              if (constraints.maxWidth >= 480)
                                Text(
                                  'PERSONAL STYLE, CONSIDERED',
                                  style: textTheme.labelSmall,
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 44),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 42,
                                  height: 2,
                                  color: VestColors.blush,
                                ),
                                const SizedBox(height: 22),
                                Text(
                                  'Clothes that know\nyour point of view.',
                                  style: textTheme.displayLarge?.copyWith(
                                    fontSize: 44,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 460),
                                  child: Text(
                                    'A few thoughtful choices bring you closer '
                                    'to an outfit that feels like you.',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: VestColors.inkFaint,
                                      fontSize: 16,
                                      height: 1.55,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'A PALETTE TO BEGIN',
                                style: textTheme.labelSmall?.copyWith(
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Row(
                                  children: [
                                    _paletteColor(VestColors.blush),
                                    _paletteColor(VestColors.moss),
                                    _paletteColor(VestColors.mustard),
                                    _paletteColor(VestColors.ink),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 22),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ProfileSetupScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('Build my style profile'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: Text(
                                  'Occasion-led picks, shaped around your style.',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _paletteColor(Color color) => Expanded(
        child: Container(
          height: 16,
          color: color,
        ),
      );
}
