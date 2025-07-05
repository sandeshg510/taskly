import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../src/values/colors.dart';

class WaveAnimation extends StatefulWidget {
  const WaveAnimation({super.key});

  @override
  WaveAnimationState createState() => WaveAnimationState();
}

class WaveAnimationState extends State<WaveAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(300, 150),
            painter: WavePainter(_controller!.value),
          );
        },
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint wavePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.brown.shade400,
          AppColors.beigeColor,
          AppColors.whiteColor,
          AppColors.lightBlueColor,
          Colors.lightBlue.shade100,
          AppColors.purpleColor,
          AppColors.purpleColor,
          AppColors.beigeColor,
        ],
        stops: const [0.14, 0.28, 0.42, 0.56, 0.7, 0.8, 0.9, 1],
      ).createShader(const Rect.fromLTRB(40, 40, 240, 240));

    // final Paint circlePaint = Paint()..color = Colors.purple;

    Path wavePath = Path();
    double amplitude = 30;
    double frequency = 2 * pi / size.width;

    // Drawing the wavy line
    for (double x = 0; x <= size.width; x++) {
      double y =
          sin(frequency * x + animationValue * 2 * pi) * amplitude +
          size.height / 2;
      if (x == 0) {
        wavePath.moveTo(x, y);
      } else {
        wavePath.lineTo(x, y);
      }
    }

    // Draw the wavy line
    canvas.drawPath(wavePath, wavePaint);

    // Draw the moving circle
    final Paint outerCirclePaint = Paint()..color = AppColors.purpleColor;
    final Paint innerCirclePaint = Paint()..color = Colors.white;

    double circleX = animationValue * size.width;
    double circleY =
        sin(frequency * circleX + animationValue * 2 * pi) * amplitude +
        size.height / 2;
    // canvas.drawCircle(Offset(circleX, circleY), 12, circlePaint);

    // Draw the larger (outer) circle
    canvas.drawCircle(Offset(circleX, circleY), 15, outerCirclePaint);

    // Draw the smaller (inner) circle on top
    canvas.drawCircle(Offset(circleX, circleY), 8, innerCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
