import 'package:flutter/material.dart';

class DotBarAnimation extends StatefulWidget {
  const DotBarAnimation({super.key});

  @override
  DotBarAnimationState createState() => DotBarAnimationState();
}

class DotBarAnimationState extends State<DotBarAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 10.0,
      end: 50.0,
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        height: 20,
        width: 100,
        child: AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First Dot
                _buildDot(Colors.grey[800]!, 10.0),
                const SizedBox(width: 10.0),
                // Second Dot
                _buildDot(Colors.grey[700]!, 10.0),
                const SizedBox(width: 10.0),
                // Third Dot that animates into a bar
                _buildBarOrDot(Colors.white, _animation!.value),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildBarOrDot(Color color, double width) {
    return Container(
      width: width,
      height: 10.0, // Keep the height small for the "bar"
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          width < 50 ? 100 : 10,
        ), // Dot when width is small, bar when large
      ),
    );
  }
}
