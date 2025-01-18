import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/business_logic/cubit/toDos_cubit/to_dos_data_cubit.dart';
import 'package:todo_app_task/constants/colors.dart';
import 'package:todo_app_task/data/repository/auth_repo.dart';
import 'package:todo_app_task/presentation/screens/login_screen.dart';
import 'package:todo_app_task/presentation/screens/main_screen.dart';
import 'package:todo_app_task/presentation/screens/on_boarding_screen.dart';
import 'package:todo_app_task/presentation/widgets/auth_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    test();
    super.initState();
  }

  void test() async {
    await getTokens(readAccessToken: true, readRefreshToken: false);
    if (accessToken.isNotEmpty) {
      // the user is logedin before
      // ignore: use_build_context_synchronously
      await context.read<ToDosDataCubit>().todoDataListCubit();

      await Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => MainScreen(),
        ),
      );
    } else {
      if (await getBoolFromPreferences() == true) {
        await Future.delayed(const Duration(seconds: 2));
        // this is the first time for the user or the user is loged out the last time
        await Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LoginScreen(),
          ),
        );
      } else {
        await Future.delayed(const Duration(seconds: 2));
        // this is the first time for the user or the user is loged out the last time
        await Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const OnBoardingScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.purple,
      body: Center(
        child: SizedBox(
            width: mediaQuery.width * (124 / 375),
            height: mediaQuery.height * (45 / 812),
            child: Image.asset('assets/images/Group 9.png')),
      ),
    );
  }
}
