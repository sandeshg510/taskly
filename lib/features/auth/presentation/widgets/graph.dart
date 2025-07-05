import 'package:flutter/material.dart';

import '../../../../src/values/colors.dart';

List<Color> colors = [
  AppColors.beigeColor,
  Colors.black,
  Colors.brown.shade200,
  Colors.black,
  Colors.blue,
  Colors.black,
  AppColors.beigeColor,
  Colors.black,
];

List<double> heights = [30, 13, 8, 30, 25, 13, 6, 20];

class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          barWidget(0),
          barWidget(1),
          barWidget(2),
          barWidget(3),
          barWidget(4),
          barWidget(5),
          barWidget(6),
          barWidget(7),
        ],
      ),
    );
  }

  barWidget(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      height: heights[index] * 2.4,
      width: 20,
      color: colors[index],
    );
  }
}
