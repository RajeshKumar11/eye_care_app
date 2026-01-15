import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Animated figure-8 dot for eye tracking exercise
class FigureEightAnimation extends StatefulWidget {
  final double size;
  final Duration duration;

  const FigureEightAnimation({
    super.key,
    this.size = 300,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<FigureEightAnimation> createState() => _FigureEightAnimationState();
}

class _FigureEightAnimationState extends State<FigureEightAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 0.5,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: FigureEightPainter(
              progress: _controller.value,
              dotColor: AppColors.primary,
              pathColor: AppColors.textHint.withOpacity(0.3),
            ),
            size: Size(widget.size, widget.size * 0.5),
          );
        },
      ),
    );
  }
}

class FigureEightPainter extends CustomPainter {
  final double progress;
  final Color dotColor;
  final Color pathColor;

  FigureEightPainter({
    required this.progress,
    required this.dotColor,
    required this.pathColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radiusX = size.width / 2 - 20;
    final radiusY = size.height / 2 - 20;

    // Draw the figure-8 path
    final pathPaint = Paint()
      ..color = pathColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    for (double t = 0; t <= 2 * pi; t += 0.01) {
      final x = centerX + radiusX * sin(t);
      final y = centerY + radiusY * sin(t) * cos(t);
      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, pathPaint);

    // Calculate dot position
    final t = progress * 2 * pi;
    final dotX = centerX + radiusX * sin(t);
    final dotY = centerY + radiusY * sin(t) * cos(t);

    // Draw glow effect
    final glowPaint = Paint()
      ..color = dotColor.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(Offset(dotX, dotY), 20, glowPaint);

    // Draw the dot
    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX, dotY), 12, dotPaint);

    // Draw inner highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX - 3, dotY - 3), 4, highlightPaint);
  }

  @override
  bool shouldRepaint(FigureEightPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
