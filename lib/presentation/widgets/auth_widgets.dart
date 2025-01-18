import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_task/business_logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:todo_app_task/business_logic/cubit/toDos_cubit/to_dos_data_cubit.dart';
import 'package:todo_app_task/constants/colors.dart';
import 'package:todo_app_task/constants/style.dart';
import 'package:todo_app_task/constants/variables.dart';
import 'package:todo_app_task/data/repository/todos_repo.dart';
import 'package:todo_app_task/presentation/screens/login_screen.dart';
import 'package:todo_app_task/presentation/screens/main_screen.dart';
import 'package:todo_app_task/presentation/screens/profile_screen.dart';
import 'package:todo_app_task/presentation/screens/sign_up_screen.dart';
import 'package:todo_app_task/presentation/widgets/app_widgets.dart';

Widget imageInOnBoardingAndLoginScreens(
    {required mediaQuery, required signupPage}) {
  return Container(
    height: (signupPage)
        ? mediaQuery.height * (300 / 812)
        : mediaQuery.height * (482 / 812),
    width: mediaQuery.width,
    constraints: const BoxConstraints(maxWidth: 600),
    child: Image.asset(
      (signupPage) ? 'assets/images/Group 8.png' : 'assets/images/ART.png',
      fit: BoxFit.fill,
    ),
  );
}

Future<void> storeBoolInPreferences(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('visitedOnBoarding', value);
}

Future<bool> getBoolFromPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('visitedOnBoarding') ??
      false; // Default to false if not found
}

Widget heightSpace({required mediaQuery, required height}) {
  return SizedBox(
    height: mediaQuery.height * (height / 812),
  );
}

Widget widthSpace({required mediaQuery, required width}) {
  return SizedBox(
    width: mediaQuery.width * (width / 375),
  );
}

void showToast({required String message, required context}) {
  Fluttertoast.cancel();
  Future.delayed(const Duration(milliseconds: 200), () {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: MyColors.purple,
        textColor: Colors.white,
        fontSize: 19);
  });
}

Widget mainButton(
    {required mediaQuery,
    required context,
    required theButtonContainsTextOnly,
    required text,
    required loginScreen,
    required addTask,
    required onBoarding}) {
  return SizedBox(
    width: mediaQuery.width * (331 / 375),
    child: BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
            onPressed: () async {
              if (onBoarding == true) {
                await storeBoolInPreferences(true);
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const LoginScreen(),
                  ),
                );
              } else {
                if (addTask == true) {
                  taskFormDataSubmitted = true;
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  context.read<AuthCubit>().emit(AuthExperienceLevelError());

                  if (navigatingToEditScreen == false) {
                    if (addTaskformkey.currentState!.validate() &&
                        displayedTaskDate.isNotEmpty &&
                        taskPriority.isNotEmpty &&
                        selectedImage!.lengthSync() > 0) {
                      displayedPageOfData = 1;
                      await context
                          .read<ToDosDataCubit>()
                          .todoDataUploadCubit();
                      // ignore: use_build_context_synchronously
                      await context.read<ToDosDataCubit>().todoDataListCubit();

                      // ignore: use_build_context_synchronously
                      await context
                          .read<ToDosDataCubit>()
                          .todoDataCreateCubit();
                      // ignore: use_build_context_synchronously
                      final toDosState = context.read<ToDosDataCubit>().state;
                      if (toDosState is ToDosDataError) {
                        showToast(
                            message: toDosState.errorMessage,
                            // ignore: use_build_context_synchronously
                            context: context);
                      } else if (toDosState is ToDosDataCreate) {
                        displayedPageOfData = 1;

                        // ignore: use_build_context_synchronously
                        await context
                            .read<ToDosDataCubit>()
                            .todoDataListCubit();

                        taskFormDataSubmitted = false;
                        taskTitle = '';
                        taskDescription = '';
                        taskImage = '';
                        taskPriority = '';
                        taskDate = null;
                        selectedImage = null;
                        displayedTaskDate = '';
                        navigatingToEditScreen = false;
                        await Navigator.pushAndRemoveUntil(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                          ModalRoute.withName('/HomeScreen'),
                        );
                      }
                    }
                  } else {
                    // editing not adding
                    if (selectedImage != null) {
                      await context
                          .read<ToDosDataCubit>()
                          .todoDataUploadCubit();
                    }
                    // ignore: use_build_context_synchronously
                    await context.read<ToDosDataCubit>().todoDataEditCubit(
                        toDoID: toDosDataList[taksDetailsIndex].sId);
                    displayedPageOfData = 1;
                    // ignore: use_build_context_synchronously
                    await context.read<ToDosDataCubit>().todoDataListCubit();
                    taskFormDataSubmitted = false;
                    taskTitle = '';
                    taskDescription = '';
                    taskImage = '';
                    taskPriority = '';
                    taskDate = null;
                    selectedImage = null;
                    displayedTaskDate = '';
                    navigatingToEditScreen = false;
                    await Navigator.pushAndRemoveUntil(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                      ModalRoute.withName('/HomeScreen'),
                    );
                  }
                } else {
                  theFormSubmitted = true;
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  context.read<AuthCubit>().emit(AuthPhoneNumberError());
                  if (loginScreen == true) {
                    if (loginformkey.currentState!.validate() &&
                        userPhoneNumber.isNotEmpty) {
                      await context.read<AuthCubit>().loginCubit();
                      // ignore: use_build_context_synchronously
                      final authState = context.read<AuthCubit>().state;
                      if (authState is AuthError) {
                        showToast(
                            message: authState.errorMessage,
                            // ignore: use_build_context_synchronously
                            context: context);
                      } else if (authState is AuthLogin) {
                        displayedPageOfData = 1;
                        // ignore: use_build_context_synchronously
                        await context
                            .read<ToDosDataCubit>()
                            .todoDataListCubit();
                        Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => MainScreen(),
                          ),
                        );
                      }
                    }
                  } else {
                    if (registerformkey.currentState!.validate() &&
                        userPhoneNumber.isNotEmpty &&
                        experienceLevel.isNotEmpty) {
                      await context.read<AuthCubit>().registerCubit();
                      // ignore: use_build_context_synchronously
                      final authState = context.read<AuthCubit>().state;
                      if (authState is AuthError) {
                        showToast(
                            message: authState.errorMessage,
                            // ignore: use_build_context_synchronously
                            context: context);
                      } else if (authState is AuthRegitster) {
                        displayedPageOfData = 1;
                        // ignore: use_build_context_synchronously
                        await context
                            .read<ToDosDataCubit>()
                            .todoDataListCubit();
                        Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => MainScreen(),
                          ),
                        );
                      }
                    }
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.purple,
              padding:
                  const EdgeInsets.only(top: 12, bottom: 12), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
            ),
            child: (theButtonContainsTextOnly)
                ? (state is AuthLoading)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Loading...',
                            textAlign: TextAlign.center,
                            style: WhiteText(context),
                          ),
                          widthSpace(mediaQuery: mediaQuery, width: 8),
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    : Text(
                        text,
                        textAlign: TextAlign.center,
                        style: WhiteText(context),
                      )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: WhiteText(context),
                      ),
                      widthSpace(mediaQuery: mediaQuery, width: 8),
                      Image.asset('assets/images/Arrow - Left.png')
                    ],
                  ));
      },
    ),
  );
}

Widget phoneNumberField(
    {required mediaQuery,
    required context,
    required authExperienceLevelErrorState}) {
  return IntlPhoneField(
    onChanged: (text) {
      userPhoneNumber = text.number;
      authExperienceLevelErrorState.emit(AuthExperienceLevelError());
    },
    onCountryChanged: (country) {
      userPhoneCountryCode = '+${country.dialCode}';
      authExperienceLevelErrorState.emit(AuthExperienceLevelError());
    },
    decoration: InputDecoration(
        errorStyle: errorRedText(context),
        contentPadding: EdgeInsets.only(
          left: mediaQuery.width * (15 / 375),
          right: mediaQuery.width * (15 / 375),
          top: mediaQuery.height * (15 / 812),
          bottom: mediaQuery.height * (15 / 812),
        ),
        filled: true,
        fillColor: MyColors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: (theFormSubmitted == true)
                ? Colors.red
                : MyColors.textFieldBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: 'phoneNumber',
        labelStyle: hintTextField(context)),
    style: hintTextField(context),
    dropdownTextStyle: countryCodeGrayText(context),
    dropdownIconPosition: IconPosition.trailing,
    dropdownIcon: const Icon(
      Icons.expand_more,
      color: MyColors.textFieldHintText,
    ),
    keyboardType: TextInputType.phone,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  );
}

Widget experienceLevelDropDownMenu(
    {required mediaQuery, required context, required isThisPriority}) {
  return BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) {
      return Container(
        width: mediaQuery.width,
        padding: EdgeInsets.only(
          left: mediaQuery.width * (15 / 375),
          right: mediaQuery.width * (15 / 375),
        ),
        decoration: BoxDecoration(
          color: (isThisPriority)
              ? priorityColor(
                  priority: (taskPriority.isEmpty) ? 'medium' : taskPriority,
                  background: true)
              : null,
          border: Border.all(
            width: 1,
            color: (isThisPriority)
                ? (taskFormDataSubmitted == true && taskPriority.isEmpty)
                    ? Colors.red
                    : Colors.transparent
                : (theFormSubmitted == true && experienceLevel.isEmpty)
                    ? Colors.red
                    : MyColors.blackColorForDropDownMenu,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton<String>(
          underline: Container(),
          menuMaxHeight: 200,
          icon: Expanded(
            child: Container(
                alignment: Alignment.centerRight,
                child: Icon((isThisPriority)
                    ? Icons.arrow_drop_down
                    : Icons.expand_more)),
          ),
          iconEnabledColor: (isThisPriority && taskPriority.isNotEmpty)
              ? priorityColor(background: false, priority: taskPriority)
              : MyColors.textFieldHintText,
          iconDisabledColor: Colors.black,
          hint: Text(
            (isThisPriority)
                ? 'Choose Priority Level'
                : 'Choose experience Level',
            style: (isThisPriority)
                ? dropDownPriorityDefaultHintText(context)
                : dropDownHintText(context),
          ),
          value: (isThisPriority)
              ? (taskPriority == '')
                  ? null
                  : taskPriority.toString()
              : (experienceLevel == '')
                  ? null
                  : experienceLevel.toString(),
          onChanged: (item) {
            if (isThisPriority) {
              taskPriority = item.toString();
              // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
              context.read<AuthCubit>().emit(AuthExperienceLevelError());
            } else {
              experienceLevel = item.toString();
              // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
              context.read<AuthCubit>().emit(AuthExperienceLevelError());
            }
          },
          items: (isThisPriority)
              ? options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option['value'],
                    child: Row(
                      children: [
                        Icon(option['icon'],
                            color: priorityColor(
                                background: false,
                                priority: option['value'])), // Add icon
                        widthSpace(
                            mediaQuery: mediaQuery,
                            width: 10), // Spacing between icon and text
                        Text(
                          option['value'] + ' Priority',
                          style: taskDetailsDataText(
                            context: context,
                            status: '',
                            isItStatus: false,
                            priority: option['value'],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()
              : experienceLevelItems,
        ),
      );
    },
  );
}

Widget myTextField(
    {required mediaQuery,
    required context,
    required hintText,
    required containsSuffixIcon,
    required suffixIconIsPassword,
    required containsPrefixIcon,
    required textFieldName,
    required isThisForDescription}) {
  return Padding(
    padding: EdgeInsets.only(bottom: mediaQuery.height * (15 / 812)),
    child: BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: (textFieldName == 'password') ? hidePassword : false,
          controller: (navigatingToEditScreen)
              ? (textFieldName == 'taskTitle')
                  ? editTitleController
                  : (textFieldName == 'taskDescription')
                      ? editDescriptionController
                      : null
              : null,
          minLines: (isThisForDescription) ? 7 : null,
          maxLines: (isThisForDescription) ? 7 : 1,
          keyboardType: (textFieldName == 'experienceYears')
              ? TextInputType.number
              : null,
          inputFormatters: (textFieldName == 'experienceYears')
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : [],
          onChanged: (text) {
            switch (textFieldName) {
              case 'userName':
                userName = text;
              case 'experienceYears':
                if (text.isEmpty) {
                  experienceYears = -1;
                } else {
                  experienceYears = int.parse(text);
                }
              case 'address':
                address = text;
              case 'password':
                password = text;
              case 'taskDescription':
                if (navigatingToEditScreen) {
                  taskDescription = text;
                  editDescriptionController.text = text;
                } else {
                  taskDescription = text;
                }
              case 'taskTitle':
                if (navigatingToEditScreen) {
                  editTitleController.text = text;
                  taskTitle = text;
                } else {
                  taskTitle = text;
                }
            }
          },
          validator: (value) {
            switch (textFieldName) {
              case 'userName':
                if (value!.isEmpty) {
                  return 'Invalid User Name';
                } else {
                  userName = value;
                }
              case 'experienceYears':
                if (value!.isEmpty) {
                  return 'Invalid Experience Years';
                } else {
                  experienceYears = int.parse(value);
                }
              case 'address':
                if (value!.isEmpty) {
                  return 'Invalid Address';
                } else {
                  address = value;
                }
              case 'password':
                if (value!.isEmpty) {
                  return 'Invalid Password';
                } else {
                  password = value;
                }
              case 'taskDescription':
                if (value!.isEmpty) {
                  return 'Invalid Description';
                } else {
                  taskDescription = value;
                }
              case 'taskTitle':
                if (value!.isEmpty) {
                  return 'Invalid Title';
                } else {
                  taskTitle = value;
                }
            }
            return null;
          },
          decoration: InputDecoration(
              errorStyle: errorRedText(context),
              contentPadding: EdgeInsets.only(
                left: mediaQuery.width * (15 / 375),
                right: mediaQuery.width * (15 / 375),
                top: mediaQuery.height * (15 / 812),
                bottom: mediaQuery.height * (15 / 812),
              ),
              filled: true,
              fillColor: MyColors.white,
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: MyColors.textFieldBorder,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              alignLabelWithHint: (isThisForDescription) ? true : null,
              prefixIcon: (containsPrefixIcon == true)
                  ? Container(
                      margin: EdgeInsets.only(
                          right: mediaQuery.width * (12 / 375),
                          left: mediaQuery.width * (15 / 375),
                          top: mediaQuery.height * (13 / 812),
                          bottom: mediaQuery.height * (13 / 812)),
                      color: Colors.green,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('011'),
                          Text('011'),
                        ],
                      ),
                    )
                  : null,
              suffixIcon: (containsSuffixIcon)
                  ? IconButton(
                      onPressed: () {
                        if (hidePassword == true) {
                          hidePassword = false;

                          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                          context.read<AuthCubit>().emit(AuthShowPassword());
                        } else {
                          hidePassword = true;

                          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                          context.read<AuthCubit>().emit(AuthShowPassword());
                        }
                      },
                      icon: Container(
                        child: (suffixIconIsPassword)
                            ? Icon(
                                (hidePassword)
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: MyColors.textFieldBorder,
                              )
                            : Image.asset('assets/images/calendar.png'),
                      ),
                    )
                  : null,
              labelText: hintText,
              labelStyle: hintTextField(context)),
          style: hintTextField(context),
        );
      },
    ),
  );
}

Widget richText(
    {required context,
    required firstText,
    required secondText,
    required goToSignupScreen}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        firstText + ' ',
        style: hintTextField(context),
      ),
      InkWell(
        onTap: () {
          theFormSubmitted = false;
          userName = '';
          userPhoneNumber = '';
          userPhoneCountryCode = '';
          experienceYears = -1;
          experienceLevel = '';
          address = '';
          password = '';
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => (goToSignupScreen)
                  ? const SignUpScreen()
                  : const LoginScreen(),
            ),
          );
        },
        child: Text(
          secondText,
          style: signInAndSignUpButton(context),
        ),
      ),
    ],
  );
}

Widget phoneNumberError(
    {required mediaQuery,
    required context,
    required value,
    required formSubmitionName,
    required thisFieldIsPhone,
    required thisFieldIsDate,
    required addedImage,
    required navigatingToEditScreen}) {
  if (navigatingToEditScreen == false) {
    if (addedImage && formSubmitionName == true) {
      if (value == null) {
        return Container(
          margin: EdgeInsets.only(
              left: mediaQuery.width * (15 / 375),
              top: (formSubmitionName == theFormSubmitted)
                  ? 0
                  : mediaQuery.height * (10 / 812)),
          alignment: Alignment.centerLeft,
          child: Text(
            "You Should Add An Image",
            style: errorRedText(context),
            textAlign: TextAlign.left,
          ),
        );
      } else {
        return Container();
      }
    } else {
      if (formSubmitionName == true && value.isEmpty) {
        return Container(
          margin: EdgeInsets.only(
              left: mediaQuery.width * (15 / 375),
              top: (formSubmitionName == theFormSubmitted)
                  ? 0
                  : mediaQuery.height * (10 / 812)),
          alignment: Alignment.centerLeft,
          child: Text(
            (thisFieldIsPhone)
                ? 'Invalid Mobile Number'
                : (thisFieldIsDate)
                    ? "You Should Choose Date"
                    : (addedImage)
                        ? "You Should Add An Image"
                        : "You Should Choose Priority Level",
            style: errorRedText(context),
            textAlign: TextAlign.left,
          ),
        );
      } else {
        return Container();
      }
    }
  } else {
    return Container();
  }
}

Widget logoutButton(
    {required context,
    required authExperienceLevelErrorState,
    required profileButton,
    required toDosDataLoadingState}) {
  return IconButton(
    onPressed: () async {
      if (profileButton == false) {
        await authExperienceLevelErrorState.logoutCubit();
        // ignore: use_build_context_synchronously
        final authState = authExperienceLevelErrorState.state;
        if (authState is AuthError) {
          showToast(
              message: authState.errorMessage,
              // ignore: use_build_context_synchronously
              context: context);
        } else if (authState is AuthLogout) {
          statusChossedButtonIndex = 0;
          displayedPageOfData = 1;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginScreen(),
            ),
          );
        }
      } else if (profileButton == true) {
        statusChossedButtonIndex = 0;
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const ProfileScreen(),
          ),
        );
        await authExperienceLevelErrorState.profileDataCubit();

        toDosDataLoadingState.emit(ToDosStatusChossedButton());

        final authState = await authExperienceLevelErrorState.state;

        if (authState is AuthError) {
          showToast(message: authState.errorMessage, context: context);
        }
      }
    },
    icon: Icon(
      (profileButton) ? Icons.account_circle_outlined : Icons.logout_rounded,
      color: (profileButton) ? MyColors.largBlackText : MyColors.purple,
    ),
  );
}
