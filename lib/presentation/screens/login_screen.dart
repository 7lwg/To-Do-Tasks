import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/business_logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:todo_app_task/constants/style.dart';
import 'package:todo_app_task/constants/variables.dart';
import 'package:todo_app_task/presentation/widgets/auth_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: loginformkey,
          child: SizedBox(
            width: mediaQuery.width,
            height: mediaQuery.height,
            child: Stack(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: imageInOnBoardingAndLoginScreens(
                      mediaQuery: mediaQuery, signupPage: false),
                ),
                heightSpace(mediaQuery: mediaQuery, height: 24),
                Container(
                  // color: Colors.red,
                  alignment: Alignment.bottomCenter,
                  width: mediaQuery.width,
                  // height: mediaQuery.height * 2 / 3,
                  margin: EdgeInsets.only(
                    left: mediaQuery.width * (24.5 / 375),
                    right: mediaQuery.width * (24.5 / 375),
                  ),
                  padding: EdgeInsets.only(
                    bottom: mediaQuery.height * (32 / 812),
                  ),              
                  child: Column(              
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login',
                          textAlign: TextAlign.left,
                          style: largBlackText(context),
                        ),
                      ),
                      heightSpace(mediaQuery: mediaQuery, height: 9),
                      phoneNumberField(
                          mediaQuery: mediaQuery,
                          context: context,
                          authExperienceLevelErrorState:
                              context.read<AuthCubit>()),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return phoneNumberError(
                              mediaQuery: mediaQuery,
                              context: context,
                              value: userPhoneNumber,
                              formSubmitionName: theFormSubmitted,
                              thisFieldIsDate: false,
                              thisFieldIsPhone: true,
                              addedImage: false,
                              navigatingToEditScreen: navigatingToEditScreen);
                        },
                      ),
                      heightSpace(mediaQuery: mediaQuery, height: 15),
                      myTextField(
                        mediaQuery: mediaQuery,
                        context: context,
                        hintText: 'Password...',
                        containsSuffixIcon: true,
                        suffixIconIsPassword: true,
                        containsPrefixIcon: false,
                        textFieldName: 'password',
                        isThisForDescription: false,
                      ),
                      heightSpace(mediaQuery: mediaQuery, height: 9),
                      mainButton(
                          mediaQuery: mediaQuery,
                          context: context,
                          theButtonContainsTextOnly: true,
                          text: 'Sign In',
                          loginScreen: true,
                          addTask: false,
                          onBoarding: false),
                      heightSpace(mediaQuery: mediaQuery, height: 24),
                      richText(
                          context: context,
                          firstText: 'Didn’t have any account?',
                          secondText: 'Sign Up here',
                          goToSignupScreen: true),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
