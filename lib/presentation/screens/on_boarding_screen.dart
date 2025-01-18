import 'package:flutter/material.dart';
import 'package:todo_app_task/constants/style.dart';
import 'package:todo_app_task/presentation/widgets/auth_widgets.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: imageInOnBoardingAndLoginScreens(
                mediaQuery: mediaQuery, signupPage: false),
          ),
          heightSpace(mediaQuery: mediaQuery, height: 24),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: mediaQuery.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: mediaQuery.width * (235 / 375),
                    child: Text('Task Management & To-Do List',
                        textAlign: TextAlign.center,
                        style: largBlackText(context)),
                  ),
                  heightSpace(mediaQuery: mediaQuery, height: 16),
                  SizedBox(
                    width: mediaQuery.width * (255 / 375),
                    child: Text(
                        "This productive tool is designed to help you better manage your task\nproject-wise conveniently!",
                        textAlign: TextAlign.center,
                        style:
                            smallGrayText(context: context, blackColor: false)),
                  ),
                  heightSpace(mediaQuery: mediaQuery, height: 32.5),
                  mainButton(
                      mediaQuery: mediaQuery,
                      context: context,
                      theButtonContainsTextOnly: false,
                      text: 'Let’s Start',
                      loginScreen: false,
                      addTask: false,
                      onBoarding: true),
                  heightSpace(mediaQuery: mediaQuery, height: 74),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
