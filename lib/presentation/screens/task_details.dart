import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:todo_app_task/constants/colors.dart';
import 'package:todo_app_task/constants/style.dart';
import 'package:todo_app_task/constants/variables.dart';
import 'package:todo_app_task/data/repository/todos_repo.dart';
import 'package:todo_app_task/presentation/widgets/app_widgets.dart';
import 'package:todo_app_task/presentation/widgets/auth_widgets.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        title: Text(
          'Task Details',
          style: myTasksLableText(context),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: mediaQuery.width * (10 / 375)),
            child: threeDotsButton(
                context: context,
                mediaQuery: mediaQuery,
                index: taksDetailsIndex,
                alignTop: false),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            width: mediaQuery.width,
            height: mediaQuery.height * (225 / 812),
            child: Image.network(
              toDosDataList[taksDetailsIndex].image,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset('assets/images/images (1).jpeg');
              },
            ),
          ),
          Container(

            width: mediaQuery.width * (331 / 375),
            margin: EdgeInsets.only(
              top: mediaQuery.height * (16 / 812),
              bottom: mediaQuery.height * (16 / 812),
              right: mediaQuery.width * (22 / 375),
              left: mediaQuery.width * (22 / 375),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    toDosDataList[taksDetailsIndex].title,
                    style: largBlackText(context),
                  ),
                ),
                heightSpace(mediaQuery: mediaQuery, height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    toDosDataList[taksDetailsIndex].desc,
                    style: smallGrayText(context: context, blackColor: true),
                  ),
                ),
              ],
            ),
          ),
          taskDetailsContainers(
              context: context,
              mediaQuery: mediaQuery,
              date: true,
              status: false),
          heightSpace(mediaQuery: mediaQuery, height: 8),
          taskDetailsContainers(
              context: context,
              mediaQuery: mediaQuery,
              date: false,
              status: true),
          heightSpace(mediaQuery: mediaQuery, height: 8),
          taskDetailsContainers(
              context: context,
              mediaQuery: mediaQuery,
              date: false,
              status: false),
          heightSpace(mediaQuery: mediaQuery, height: 16),
          SizedBox(
            height: mediaQuery.width * (326 / 375),
            width: mediaQuery.width * (326 / 375),
            child: QrImageView(
              data: toDosDataList[taksDetailsIndex].sId,
              version: QrVersions.auto,
            ),
          ),
          heightSpace(mediaQuery: mediaQuery, height: 30),
        ],
      )),
    );
  }
}
