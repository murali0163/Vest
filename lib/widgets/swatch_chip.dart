import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A chip styled like a fabric swatch tag — a perforated edge on the left
/// (drawn via a dashed CustomPainter) evokes a torn sample card.
/// Used for style/occasion text selectors.
class SwatchChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SwatchChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.only(left: 14, right: 16, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: selected ? VestColors.ink : VestColors.card,
          border: Border.all(
            color: selected ? VestColors.ink : VestColors.line,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: const Size(6, 18),
              painter: _PerforationPainter(
                color: selected ? VestColors.canvas : VestColors.line,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? VestColors.canvas : VestColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerforationPainter extends CustomPainter {
  final Color color;
  _PerforationPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    const dotCount = 4;
    final gap = size.height / dotCount;
    for (int i = 0; i < dotCount; i++) {
      canvas.drawCircle(
        Offset(size.width / 2, gap * i + gap / 2),
        1.1,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PerforationPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// A round color-swatch selector, used for skin tone picking.
class ToneSwatch extends StatelessWidget {
  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ToneSwatch({
    super.key,
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? VestColors.ink : Colors.transparent,
                width: 2.5,
              ),
              boxShadow: selected
                  ? [
                BoxShadow(
                  color: VestColors.ink.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected ? VestColors.ink : VestColors.inkFaint,
            ),
          ),
        ],
      ),
    );
  }
}