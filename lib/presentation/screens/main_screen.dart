import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/business_logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:todo_app_task/business_logic/cubit/toDos_cubit/to_dos_data_cubit.dart';
import 'package:todo_app_task/constants/style.dart';
import 'package:todo_app_task/constants/variables.dart';
import 'package:todo_app_task/presentation/widgets/app_widgets.dart';
import 'package:todo_app_task/presentation/widgets/auth_widgets.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  // ignore: prefer_typing_uninitialized_variables
  var toDosDataState;

  @override
  Widget build(BuildContext context) {
    toDosDataState = context.read<ToDosDataCubit>().state;
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          toDosDataState is! ToDosDataLoading) {
        toDosDataState = context.read<ToDosDataCubit>().state;
        if (toDosDataState is! ToDosDataInfiniteScroll) {
          displayedPageOfData++;
          await context.read<ToDosDataCubit>().todoDataListCubit();
        }
      }
    });

    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Logo',
          style: largBlackText(context),
        ),
        actions: [
          logoutButton(
            context: context,
            authExperienceLevelErrorState: context.read<AuthCubit>(),
            profileButton: true,
            toDosDataLoadingState: context.read<ToDosDataCubit>(),
          ),
          logoutButton(
            context: context,
            authExperienceLevelErrorState: context.read<AuthCubit>(),
            profileButton: false,
            toDosDataLoadingState: context.read<ToDosDataCubit>(),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: mediaQuery.width,
            height: mediaQuery.height,
            padding: EdgeInsets.only(
                left: mediaQuery.width * (22 / 375),
                right: mediaQuery.width * (22 / 375)),
            child: Column(
              children: [
                heightSpace(mediaQuery: mediaQuery, height: 24),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    textAlign: TextAlign.left,
                    'My Tasks',
                    style: myTasksLableText(context),
                  ),
                ),
                heightSpace(mediaQuery: mediaQuery, height: 16),
                statusButtons(mediaQuery: mediaQuery),
                heightSpace(mediaQuery: mediaQuery, height: 16),
                toDosListView(mediaQuery: mediaQuery, context: context),
              ],
            ),
          ),
          circularButtons(
              context: context,
              mediaQuery: mediaQuery,
              addButton: false,
              toDosDataCubit: context.read<ToDosDataCubit>()),
          circularButtons(
              context: context,
              mediaQuery: mediaQuery,
              addButton: true,
              toDosDataCubit: context.read<ToDosDataCubit>()),
          cameraQrScanner(
              mediaQuery: mediaQuery,
              toDosDataCubit: context.read<ToDosDataCubit>())
        ],
      ),
    );
  }
}
