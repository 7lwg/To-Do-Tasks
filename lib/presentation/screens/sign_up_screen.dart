import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/business_logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:todo_app_task/constants/style.dart';
import 'package:todo_app_task/constants/variables.dart';
import 'package:todo_app_task/presentation/widgets/auth_widgets.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: registerformkey,
          child: SizedBox(
            width: mediaQuery.width,
            height: mediaQuery.height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                      child: imageInOnBoardingAndLoginScreens(
                          mediaQuery: mediaQuery, signupPage: true)),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: mediaQuery.width,
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
                          'Sign Up',
                          textAlign: TextAlign.left,
                          style: largBlackText(context),
                        ),
                      ),
                      heightSpace(mediaQuery: mediaQuery, height: 9),
                      myTextField(
                        mediaQuery: mediaQuery,
                        context: context,
                        hintText: 'Name...',
                        containsSuffixIcon: false,
                        suffixIconIsPassword: false,
                        containsPrefixIcon: false,
                        textFieldName: 'userName',
                        isThisForDescription: false,
                      ),
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
                        hintText: 'Years of experience...',
                        containsSuffixIcon: false,
                        suffixIconIsPassword: false,
                        containsPrefixIcon: false,
                        textFieldName: 'experienceYears',
                        isThisForDescription: false,
                      ),
                      experienceLevelDropDownMenu(
                          mediaQuery: mediaQuery,
                          context: context,
                          isThisPriority: false),
                      heightSpace(mediaQuery: mediaQuery, height: 15),
                      myTextField(
                        mediaQuery: mediaQuery,
                        context: context,
                        hintText: 'Address...',
                        containsSuffixIcon: false,
                        suffixIconIsPassword: false,
                        containsPrefixIcon: false,
                        textFieldName: 'address',
                        isThisForDescription: false,
                      ),
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
                          text: 'Sign Up',
                          loginScreen: false,
                          addTask: false,
                          onBoarding: false),
                      heightSpace(mediaQuery: mediaQuery, height: 24),
                      richText(
                        context: context,
                        firstText: 'Already have any account?',
                        secondText: 'Sign in',
                        goToSignupScreen: false,
                      ),
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
