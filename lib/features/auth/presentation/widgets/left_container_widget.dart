import 'package:flutter/material.dart';

import '../../../../src/values/colors.dart';

class LeftContainerWidget extends StatelessWidget {
  final Color color;
  final double width;
  final Gradient gradient;

  const LeftContainerWidget({
    super.key,
    required this.color,
    required this.width,
    this.gradient = const LinearGradient(
      colors: [AppColors.whiteColor, AppColors.beigeColor],
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(60),
          topLeft: Radius.circular(60),
        ),
      ),
    );
  }
}
