import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

class ProductArtwork extends StatelessWidget {
  final Product product;

  const ProductArtwork({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final background = Color.lerp(product.swatchColor, VestColors.card, 0.84)!;

    return Semantics(
      image: true,
      label: 'Product photo unavailable for ${product.name}',
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  background,
                  Color.lerp(background, VestColors.canvasAlt, 0.55)!,
                ],
              ),
            ),
          ),
          CustomPaint(painter: _TextilePainter(color: product.swatchColor)),
          Center(
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: VestColors.card.withValues(alpha: 0.72),
                shape: BoxShape.circle,
                border: Border.all(
                  color: product.swatchColor.withValues(alpha: 0.35),
                ),
              ),
              child: Icon(
                Icons.checkroom_outlined,
                size: 38,
                color: VestColors.ink.withValues(alpha: 0.78),
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: VestColors.card.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'PHOTO UNAVAILABLE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      letterSpacing: 0.5,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextilePainter extends CustomPainter {
  final Color color;

  const _TextilePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var index = 0; index < 5; index++) {
      final inset = 16.0 + index * 12;
      canvas.drawLine(
        Offset(size.width * 0.62 + inset, 0),
        Offset(size.width * 0.62 - inset, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TextilePainter oldDelegate) =>
      oldDelegate.color != color;
}
