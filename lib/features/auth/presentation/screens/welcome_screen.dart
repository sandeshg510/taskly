import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/features/auth/presentation/screens/sign_in_screen.dart';

import '../../../../src/values/colors.dart';
import '../widgets/dot_bar_animation.dart';
import '../widgets/graph.dart';
import '../widgets/wave_animation.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: height * 0.25,
                        width: width * 0.38,
                        decoration: BoxDecoration(
                          color: AppColors.beigeColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(width * 0.19),
                            bottomRight: Radius.circular(width * 0.19),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.095,
                        left: width * 0.055,
                        right: width * 0.055,
                        bottom: width * 0.055,
                        child: Container(
                          height: height * 0.126,
                          width: width * 0.28,
                          decoration: BoxDecoration(
                            color: AppColors.blackColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: height * 0.166,
                      decoration: BoxDecoration(
                        gradient: AppColors.welcomeScreenGradient,
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(height * 0.83),
                          topLeft: Radius.circular(height * 0.83),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: width * 0.8,
              height: height * 0.166,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(height * 0.83),
                  topRight: Radius.circular(height * 0.83),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 28),
                child: Graph(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: width * 0.19),
              child: Container(
                alignment: AlignmentDirectional.centerEnd,
                width: double.infinity,
                height: height * 0.166,
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(height * 0.83),
                    topLeft: Radius.circular(height * 0.83),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 55),
                  child: WaveAnimation(),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.only(left: width * 0.15),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Create Your',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: height * 0.041,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Grotesk',
                      ),
                    ),
                    TextSpan(
                      text: '\nTasks ',
                      style: TextStyle(
                        fontSize: height * 0.041,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Grotesk',
                        foreground: Paint()
                          ..shader = LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.brown.shade400,
                              AppColors.beigeColor,
                              AppColors.lightBlueColor,
                              Colors.lightBlue.shade300,
                              AppColors.purpleColor,
                              AppColors.beigeColor,
                            ],
                            stops: const [0.08, 0.15, 0.4, 0.5, 0.6, 1.0],
                          ).createShader(const Rect.fromLTRB(0, 0, 150, 150)),
                      ),
                    ),
                    TextSpan(
                      text: 'And',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: height * 0.041,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Grotesk',
                      ),
                    ),
                    TextSpan(
                      text: '\nManage Your',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: height * 0.041,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Grotesk',
                      ),
                    ),
                    TextSpan(
                      text: '\nWork.',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: height * 0.041,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Grotesk',
                      ),
                    ),
                  ],
                ),
                maxLines: 4, // Set the maximum number of lines
              ),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: DotBarAnimation(),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: width * 0.65, right: width * 0.07),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          },
          child: Container(
            height: height * 0.054,
            width: width * 0.25,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.brown.shade400,
                  AppColors.beigeColor,
                  AppColors.lightBlueColor,
                  Colors.lightBlue.shade300,
                  AppColors.purpleColor,
                  AppColors.beigeColor,
                ],
                stops: const [0.08, 0.15, 0.4, 0.5, 0.6, 1.0],
              ),
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(height * 0.027)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Start',
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  CupertinoIcons.arrow_right,
                  size: 18,
                  color: AppColors.blackColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
