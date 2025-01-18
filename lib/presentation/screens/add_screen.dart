import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/business_logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:todo_app_task/constants/style.dart';
import 'package:todo_app_task/constants/variables.dart';
import 'package:todo_app_task/data/repository/todos_repo.dart';
import 'package:todo_app_task/presentation/widgets/app_widgets.dart';
import 'package:todo_app_task/presentation/widgets/auth_widgets.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (navigatingToEditScreen) ? 'Edit task' : 'Add new task',
          style: myTasksLableText(context),
        ),
        centerTitle: false,
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          taskFormDataSubmitted = false;
          navigatingToEditScreen = false;
          taskTitle = '';
          taskDescription = '';
          taskImage = '';
          taskPriority = '';
          taskDate = null;
          displayedTaskDate = '';
          selectedImage = null;
          return true;
        },
        child: SingleChildScrollView(
          child: Form(
            key: addTaskformkey,
            child: Center(
              child: SizedBox(
                width: mediaQuery.width * (331 / 375),
                child: Column(
                  children: [
                    addImageWidget(mediaQuery: mediaQuery),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return phoneNumberError(
                            mediaQuery: mediaQuery,
                            context: context,
                            value: selectedImage,
                            formSubmitionName: taskFormDataSubmitted,
                            thisFieldIsDate: false,
                            thisFieldIsPhone: false,
                            addedImage: true,
                            navigatingToEditScreen: navigatingToEditScreen);
                      },
                    ),
                    heightSpace(mediaQuery: mediaQuery, height: 16),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Task Title',
                            style: addNewTaskLabalsText(context),
                          ),
                        ),
                        heightSpace(mediaQuery: mediaQuery, height: 8),
                        myTextField(
                          mediaQuery: mediaQuery,
                          context: context,
                          hintText: "Enter title here...",
                          containsSuffixIcon: false,
                          suffixIconIsPassword: false,
                          containsPrefixIcon: false,
                          textFieldName: 'taskTitle',
                          isThisForDescription: false,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Task Description',
                            style: addNewTaskLabalsText(context),
                          ),
                        ),
                        heightSpace(mediaQuery: mediaQuery, height: 8),
                        myTextField(
                          mediaQuery: mediaQuery,
                          context: context,
                          hintText: "Enter description here...",
                          containsSuffixIcon: false,
                          suffixIconIsPassword: false,
                          containsPrefixIcon: false,
                          textFieldName: 'taskDescription',
                          isThisForDescription: true,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Priority',
                            style: addNewTaskLabalsText(context),
                          ),
                        ),
                        heightSpace(mediaQuery: mediaQuery, height: 8),
                        experienceLevelDropDownMenu(
                            context: context,
                            mediaQuery: mediaQuery,
                            isThisPriority: true),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return phoneNumberError(
                                mediaQuery: mediaQuery,
                                context: context,
                                value: taskPriority,
                                formSubmitionName: taskFormDataSubmitted,
                                thisFieldIsDate: false,
                                thisFieldIsPhone: false,
                                addedImage: false,
                                navigatingToEditScreen: navigatingToEditScreen);
                          },
                        ),
                        heightSpace(mediaQuery: mediaQuery, height: 16),
                        (!navigatingToEditScreen)
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Due Date',
                                  style: addNewTaskLabalsText(context),
                                ),
                              )
                            : Container(),
                        (!navigatingToEditScreen)
                            ? heightSpace(mediaQuery: mediaQuery, height: 8)
                            : Container(),
                        (!navigatingToEditScreen)
                            ? createdOrUpdatedDate(mediaQuery: mediaQuery)
                            : Container(),
                      ],
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return phoneNumberError(
                            mediaQuery: mediaQuery,
                            context: context,
                            value: displayedTaskDate,
                            formSubmitionName: taskFormDataSubmitted,
                            thisFieldIsDate: true,
                            thisFieldIsPhone: false,
                            addedImage: false,
                            navigatingToEditScreen: navigatingToEditScreen);
                      },
                    ),
                    heightSpace(mediaQuery: mediaQuery, height: 29),
                    mainButton(
                        mediaQuery: mediaQuery,
                        context: context,
                        theButtonContainsTextOnly: true,
                        text:
                            (navigatingToEditScreen) ? 'Edit Task' : 'Add Task',
                        loginScreen: false,
                        addTask: true,
                        onBoarding: false),
                    heightSpace(mediaQuery: mediaQuery, height: 30)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
