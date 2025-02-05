import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaterProgressCircle extends StatelessWidget {
  final double progress;
  final double current;
  final double goal;

  const WaterProgressCircle({
    super.key,
    required this.progress,
    required this.current,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: _WaterProgressPainter(
          progress: progress.clamp(0.0, 1.0),
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class _WaterProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _WaterProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    // 背景圓環
    final bgPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawCircle(center, radius, bgPaint);

    // 進度圓環
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_WaterProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
