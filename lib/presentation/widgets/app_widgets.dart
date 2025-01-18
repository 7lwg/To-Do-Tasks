import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:todo_app_task/business_logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:todo_app_task/business_logic/cubit/toDos_cubit/to_dos_data_cubit.dart';
import 'package:todo_app_task/constants/colors.dart';
import 'package:todo_app_task/constants/style.dart';
import 'package:todo_app_task/constants/variables.dart';
import 'package:todo_app_task/data/repository/todos_repo.dart';
import 'package:todo_app_task/presentation/screens/add_screen.dart';
import 'package:todo_app_task/presentation/screens/task_details.dart';
import 'package:todo_app_task/presentation/widgets/auth_widgets.dart';

Widget statusButtons({required mediaQuery}) {
  return BlocBuilder<ToDosDataCubit, ToDosDataState>(
    builder: (context, state) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 4; i++)
              Padding(
                padding: EdgeInsets.only(
                  left: (i == 0) ? 0 : mediaQuery.width * (8 / 375),
                ),
                child: SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(mediaQuery.width * (44 / 375),
                          mediaQuery.height * (36 / 812)),
                      padding: EdgeInsets.only(
                          left: mediaQuery.width * (12 / 375),
                          right: mediaQuery.width * (12 / 375),
                          bottom: mediaQuery.height * (8 / 812),
                          top: mediaQuery.height * (8 / 812)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            24.0), // Set the desired border radius
                      ),
                      backgroundColor: (statusChossedButtonIndex == i)
                          ? MyColors.purple
                          : MyColors.statusUnchossedButtonsBackground,
                    ),
                    onPressed: () {
                      statusChossedButtonIndex = i;
                      context
                          .read<ToDosDataCubit>()
                          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                          .emit(ToDosStatusChossedButton());
                    },
                    child: Text(
                      statusFourButtonString[i],
                      style: statusButtonsText(
                        context: context,
                        chossedButton:
                            (statusChossedButtonIndex == i) ? true : false,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

String dateConverter({required date, required firstFormate}) {
  if (firstFormate == true) {
    return DateFormat('d MMMM, yyyy').format(DateTime.parse(date));
  } else {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
  }
}

Widget toDosListView({required mediaQuery, required context}) {
  return BlocBuilder<ToDosDataCubit, ToDosDataState>(
    builder: (context, state) {
      return Expanded(
        child: ListView.builder(
          controller: scrollController,
          itemCount: (statusChossedButtonIndex == 0)
              ? toDosDataList.length + 1
              : toDosDataList
                      .where((element) =>
                          element.status ==
                          statusFourButtonValues[statusChossedButtonIndex])
                      .length +
                  1,
          itemBuilder: (context, index) {
            if (statusChossedButtonIndex == 0) {
              statusChoiceResult.clear();
              statusChoiceResult.addAll(toDosDataList);
            } else {
              statusChoiceResult.clear();
              statusChoiceResult.addAll(toDosDataList.where((element) =>
                  element.status ==
                  statusFourButtonValues[statusChossedButtonIndex]));
            }
            if (toDosDataList
                    .where((element) =>
                        element.status ==
                        statusFourButtonValues[statusChossedButtonIndex])
                    .isEmpty &&
                statusChossedButtonIndex != 0) {
              return Center(
                child: Text(
                  'No ToDos Found',
                  style: largBlackText(context),
                ),
              );
            } else if (state is ToDosDataError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: largBlackText(context),
                ),
              );
            } else if (state is ToDosDataEmpty) {
              return Center(
                child: Text(
                  'No ToDos Created',
                  style: largBlackText(context),
                ),
              );
            } else {
              if (state is ToDosDataRefresher &&
                  index == ((displayedPageOfData - 1) * 20)) {
                showToast(
                    message: 'More ToDos Fetched',
                    // ignore: use_build_context_synchronously
                    context: context);
              } else {}
              if (index < statusChoiceResult.length) {
                return InkWell(
                  onTap: () {
                    taksDetailsIndex = index;
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const TaskDetails(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: mediaQuery.height * (5 / 812),
                        bottom: mediaQuery.height * (5 / 812)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: mediaQuery.width * (64 / 375),
                          height: mediaQuery.height * (64 / 812),
                          child: Image.network(
                            statusChoiceResult[index].image,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return Image.asset(
                                  'assets/images/images (1).jpeg');
                            },
                          ),
                        ),
                        SizedBox(
                          width: mediaQuery.width * (219 / 375),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: mediaQuery.height * (4 / 812)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: (statusChoiceResult[index]
                                                  .status ==
                                              'waiting')
                                          ? mediaQuery.width * (156 / 375)
                                          : (statusChoiceResult[index].status ==
                                                  'inprogress')
                                              ? mediaQuery.width * (139 / 375)
                                              : mediaQuery.width * (151 / 375),
                                      child: Text(
                                        statusChoiceResult[index].title,
                                        style: myTasksLableText(context),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.green,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: (statusChoiceResult[index]
                                                    .status ==
                                                'waiting')
                                            ? MyColors
                                                .statusWatingBackgroundColor
                                            : (statusChoiceResult[index]
                                                        .status ==
                                                    'inprogress')
                                                ? MyColors
                                                    .statusInprogressBackgroundColor
                                                : MyColors
                                                    .statusFinishedBackgroundColor,
                                      ),
                                      padding: EdgeInsets.only(
                                        top: mediaQuery.height * (2 / 812),
                                        bottom: mediaQuery.height * (2 / 812),
                                        left: mediaQuery.width * (6 / 375),
                                        right: mediaQuery.width * (6 / 375),
                                      ),
                                      child: Text(
                                        statusChoiceResult[index].status,
                                        style: statusLableText(
                                            context: context,
                                            status: statusChoiceResult[index]
                                                .status),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: mediaQuery.width * (219 / 375),
                                margin: EdgeInsets.only(
                                    bottom: mediaQuery.height * (4 / 812)),
                                child: Text(
                                  statusChoiceResult[index].desc,
                                  style: smallGrayText(
                                      context: context, blackColor: false),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: mediaQuery.width * (219 / 375),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.flag_outlined,
                                          color: (statusChoiceResult[index]
                                                      .priority ==
                                                  'low')
                                              ? MyColors.statusFinishedTextColor
                                              : (statusChoiceResult[index]
                                                          .priority ==
                                                      'medium')
                                                  ? MyColors
                                                      .statusInprogressTextColor
                                                  : MyColors
                                                      .statusWatingTextColor,
                                        ),
                                        Text(
                                          statusChoiceResult[index].priority,
                                          style: priorityLableText(
                                              context: context,
                                              priority:
                                                  statusChoiceResult[index]
                                                      .priority),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      dateConverter(
                                          date: statusChoiceResult[index]
                                              .updatedAt,
                                          firstFormate: false),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              bottom: mediaQuery.height * (60 / 812)),
                          child: threeDotsButton(
                            context: context,
                            mediaQuery: mediaQuery,
                            index: index,
                            alignTop: true,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else if (state is ToDosDataLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is ToDosDataInfiniteScroll) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'You have reached the end',
                      style: toDosListEndText(context),
                    ),
                  ),
                );
              }
            }
            return null;
          },
        ),
      );
    },
  );
}

Widget threeDotsButton(
    {required context,
    required mediaQuery,
    required index,
    required alignTop}) {
  return Align(
    alignment: (alignTop) ? Alignment.topCenter : Alignment.center,
    child: PopupMenuButton<String>(
      offset: Offset(0, mediaQuery.height * (30 / 812)),
      constraints: BoxConstraints(maxWidth: mediaQuery.width * (82 / 375)),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      color: MyColors.white,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,

      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            onTap: () async {
              // toDo Edit
              taksDetailsIndex = index;
              navigatingToEditScreen = true;
              if (navigatingToEditScreen) {
                taskTitle = toDosDataList[taksDetailsIndex].title;
                taskDescription = toDosDataList[taksDetailsIndex].desc;
                taskImage = toDosDataList[taksDetailsIndex].image;
                taskPriority = toDosDataList[taksDetailsIndex].priority;
                displayedTaskDate = dateConverter(
                    date: toDosDataList[taksDetailsIndex].updatedAt,
                    firstFormate: false);
                selectedImage = null;
              }
              if (navigatingToEditScreen) {
                editTitleController.text = taskTitle;

                editDescriptionController.text = taskDescription;
              }
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AddScreen(),
                ),
              );
            },
            height: 0,
            value: 'Edit',
            child: Container(
                width: mediaQuery.width * (50 / 375),
                height: mediaQuery.height * (36 / 812),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Edit',
                  style: popupMenuButtonText(context: context, delete: false),
                )),
          ),
          const PopupMenuDivider(
            height: 10,
          ),
          PopupMenuItem<String>(
            onTap: () async {
              // toDo Delete
              await context
                  .read<ToDosDataCubit>()
                  .todoDataDeleteCubit(toDoID: statusChoiceResult[index].sId);
            },
            height: 0,
            value: 'Delete',
            child: Container(
                width: mediaQuery.width * (50 / 375),
                height: mediaQuery.height * (36 / 812),
                alignment: Alignment.center,
                child: Text(
                  'Delete',
                  style: popupMenuButtonText(
                    context: context,
                    delete: true,
                  ),
                )),
          ),
        ];
      },
      child: const Icon(Icons.more_vert), // Icon to trigger the menu
    ),
  );
}

Widget circularButtons(
    {required context,
    required mediaQuery,
    required addButton,
    required toDosDataCubit}) {
  return Align(
    alignment: Alignment.bottomRight,
    child: Container(
      width: (addButton)
          ? mediaQuery.height * (64 / 812)
          : mediaQuery.height * (50 / 812),
      height: (addButton)
          ? mediaQuery.height * (64 / 812)
          : mediaQuery.height * (50 / 812),
      margin: EdgeInsets.only(
        right: (addButton)
            ? mediaQuery.height * (24 / 812)
            : mediaQuery.height * (31 / 812),
        bottom: (addButton)
            ? mediaQuery.height * (32 / 812)
            : mediaQuery.height * (110 / 812),
      ),
      decoration: BoxDecoration(
          color: (addButton)
              ? MyColors.purple
              : MyColors.scanButtonBackgroundColor,
          borderRadius: BorderRadius.circular(32)),
      child: InkWell(
        onTap: () async {
          if (addButton == true) {
            statusChossedButtonIndex = 0;
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const AddScreen(),
              ),
            );
            await toDosDataCubit.emit(ToDosStatusChossedButton());
          } else {
            _toggleCamera(context: context, toDosDataCubit: toDosDataCubit);
          }
        },
        child: BlocBuilder<ToDosDataCubit, ToDosDataState>(
          builder: (context, state) {
            return Center(
              child: Icon(
                (addButton)
                    ? Icons.add
                    : (isCameraActive)
                        ? Icons.close
                        : Icons.qr_code_2_outlined,
                color: (addButton) ? MyColors.white : MyColors.purple,
                size: (addButton) ? 32 : 24,
              ),
            );
          },
        ),
      ),
    ),
  );
}

Widget profileScreen(
    {required context, required mediaQuery, required profileData}) {
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(top: mediaQuery.height * (24 / 812)),
    child: Column(
      children: [
        for (int i = 0; i < 5; i++)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyColors.profileContainerBackgroundColor,
            ),
            margin: EdgeInsets.only(bottom: mediaQuery.height * (8 / 812)),
            padding: EdgeInsets.only(
              top: mediaQuery.height * (12 / 812),
              bottom: mediaQuery.height * (12 / 812),
              right: mediaQuery.width * (15 / 375),
              left: mediaQuery.width * (15 / 375),
            ),
            width: mediaQuery.width * (326 / 375),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileLabes[i],
                      style: profileDataLableText(context),
                    ),
                    Text(
                      (i == 0)
                          ? profileData!.displayName
                          : (i == 1)
                              ? profileData!.username
                              : (i == 2)
                                  ? profileData!.level
                                  : (i == 3)
                                      ? profileData!.experienceYears.toString()
                                      : profileData!.address,
                      style: profileDataText(context),
                    )
                  ],
                ),
                (i == 1)
                    ? IconButton(
                        color: MyColors.purple,
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: profileData!.username));
                          showToast(
                              context: context,
                              message: 'Text copied to clipboard!');
                        },
                        icon: const Icon(Icons.copy),
                      )
                    : Container()
              ],
            ),
          )
      ],
    ),
  );
}

statusColor({required status, required background}) {
  if (status == 'waiting') {
    if (background == true) {
      return MyColors.statusWatingBackgroundColor;
    } else {
      return MyColors.statusWatingTextColor;
    }
  } else if (status == 'inprogress') {
    if (background == true) {
      return MyColors.statusInprogressBackgroundColor;
    } else {
      return MyColors.statusInprogressTextColor;
    }
  } else {
    if (background == true) {
      return MyColors.statusFinishedBackgroundColor;
    } else {
      return MyColors.statusFinishedTextColor;
    }
  }
}

priorityColor({required priority, required background}) {
  if (priority == 'low') {
    if (background == true) {
      return MyColors.statusFinishedBackgroundColor;
    } else {
      return MyColors.statusFinishedTextColor;
    }
  } else if (priority == 'medium') {
    if (background == true) {
      return MyColors.statusInprogressBackgroundColor;
    } else {
      return MyColors.statusInprogressTextColor;
    }
  } else {
    if (background == true) {
      return MyColors.statusWatingBackgroundColor;
    } else {
      return MyColors.statusWatingTextColor;
    }
  }
}

Widget taskDetailsContainers(
    {required context, required mediaQuery, required date, required status}) {
  return Container(
    width: mediaQuery.width * (326 / 375),
    height: mediaQuery.height * (50 / 812),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (status)
            ? statusColor(
                status: toDosDataList[taksDetailsIndex].status,
                background: true)
            : priorityColor(
                priority: toDosDataList[taksDetailsIndex].priority,
                background: true)),
    padding: EdgeInsets.only(
      left: mediaQuery.width * (24 / 375),
      right: mediaQuery.width * (10 / 375),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (date)
                ? Text(
                    'End Date',
                    style: taskDetailsLableText(context),
                  )
                : Container(),
            (date == true || status == true)
                ? Text(
                    (date)
                        ? dateConverter(
                            date: toDosDataList[taksDetailsIndex].createdAt,
                            firstFormate: true)
                        : toDosDataList[taksDetailsIndex].status,
                    style: (date)
                        ? smallGrayText(context: context, blackColor: true)
                        : taskDetailsDataText(
                            context: context,
                            status: toDosDataList[taksDetailsIndex].status,
                            isItStatus: true,
                            priority: '',
                          ),
                  )
                : SizedBox(
                    child: Row(
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          color: priorityColor(
                              priority:
                                  toDosDataList[taksDetailsIndex].priority,
                              background: false),
                        ),
                        widthSpace(mediaQuery: mediaQuery, width: 10),
                        Text(
                          '${toDosDataList[taksDetailsIndex].priority} Priority',
                          style: taskDetailsDataText(
                            context: context,
                            status: '',
                            isItStatus: false,
                            priority: toDosDataList[taksDetailsIndex].priority,
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
        Container(
            margin: EdgeInsets.only(right: mediaQuery.width * (10 / 375)),
            child: Icon((date) ? Icons.calendar_month_outlined : null,
                color: MyColors.purple, size: 24))
      ],
    ),
  );
}

// Qr code
void _onQRViewCreated(QRViewController qrController, BuildContext context) {
  controller = qrController;
  qrController.scannedDataStream.listen((scanData) {
    if (!isScanning) {
      taksDetailsIndex =
          toDosDataList.indexWhere((element) => element.sId == scanData.code);

      isScanning = true; // Prevent multiple scans
      controller?.pauseCamera(); // Pause camera after scanning
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TaskDetails(),
        ),
      ).then((_) {
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        context.read<ToDosDataCubit>().emit(ToDoDataQrScan());
        isCameraActive = false; // Close the camera
        isScanning = false;
      });
    }
  });
}

void _toggleCamera(
    {required BuildContext context, required ToDosDataCubit toDosDataCubit}) {
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  toDosDataCubit.emit(ToDoDataQrScan());
  isCameraActive = !isCameraActive;
  if (isCameraActive) {
    controller?.resumeCamera(); // Open camera
  } else {
    controller?.stopCamera(); // Close camera
  }
}

Widget cameraQrScanner(
    {required mediaQuery, required ToDosDataCubit toDosDataCubit}) {
  return BlocBuilder<ToDosDataCubit, ToDosDataState>(
    builder: (context, state) {
      return Align(
        alignment: Alignment.center,
        child: (isCameraActive)
            ? Container(
                width: mediaQuery.width * (300 / 375),
                height: mediaQuery.width * (340 / 375),
                constraints:
                    const BoxConstraints(maxWidth: 500, maxHeight: 500),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 4, // Shadow spread
                      blurRadius: 8, // Shadow blur
                      offset: const Offset(0, 3), // Shadow offset
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Align(
                      child: Container(
                        width: mediaQuery.width * (300 / 375),
                        height: mediaQuery.width * (300 / 375),
                        constraints:
                            const BoxConstraints(maxWidth: 500, maxHeight: 500),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: (QRViewController controller) =>
                                _onQRViewCreated(controller, context),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: mediaQuery.width * (40 / 375),
                      child: const Center(
                        child: Text(
                          'QR Code Scanner',
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      );
    },
  );
}

void pickTaskDate(
    {required BuildContext context, required navigatingToEditScreen}) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: (navigatingToEditScreen)
        ? DateFormat('dd/MM/yyyy').parse(displayedTaskDate)
        : DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );
  if (pickedDate != null) {
    taskDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    displayedTaskDate = DateFormat('yyyy-MM-dd').format(taskDate!);

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
    context.read<AuthCubit>().emit(AuthInitial());
  }
}

Future getImageFromGallary({required openCamera}) async {
  final pickedFile = await picker.pickImage(
      source: (openCamera) ? ImageSource.camera : ImageSource.gallery);

  if (pickedFile != null) {
    final temporaryImage = File(pickedFile.path);
    selectedImage = temporaryImage;
  }
}

Widget createdOrUpdatedDate({required mediaQuery}) {
  return BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) {
      return InkWell(
        onTap: () {
          pickTaskDate(
              context: context, navigatingToEditScreen: navigatingToEditScreen);
        },
        child: Container(
          width: mediaQuery.width * (331 / 375),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 1,
                  color: (taskFormDataSubmitted == true &&
                          displayedTaskDate.isEmpty)
                      ? Colors.red
                      : MyColors.textFieldBorder)),
          padding: EdgeInsets.only(
              left: mediaQuery.width * (15 / 375),
              right: mediaQuery.width * (15 / 375),
              top: mediaQuery.height * (15 / 812),
              bottom: mediaQuery.height * (15 / 812)),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text((displayedTaskDate.isNotEmpty)
                  ? displayedTaskDate
                  : 'Choose due date...'),
              const Icon(
                Icons.calendar_month_outlined,
                color: MyColors.purple,
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget addImageWidget({required mediaQuery}) {
  return BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: (selectedImage == null &&
                    taskFormDataSubmitted == true &&
                    navigatingToEditScreen == false)
                ? Colors.red
                : MyColors.purple,
          ),
        ),
        width: mediaQuery.width * (231 * 375),
        padding: EdgeInsets.only(
            top: mediaQuery.height * (16 / 812),
            bottom: mediaQuery.height * (16 / 812)),
        margin: EdgeInsets.only(
          top: mediaQuery.height * (24 / 812),
        ),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: MyColors.scanButtonBackgroundColor,
                  title: const Text('Choose an Option'),
                  content: Text(
                    'Would you like to upload the image from the files or tack it with the gallery',
                    style: myTasksLableText(context),
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: Text('Camera',
                              style: countryCodeGrayText(context)),
                          onPressed: () async {
                            Navigator.of(context).pop(); // Close the dialog
                            getImageFromGallary(openCamera: true);
                          },
                        ),
                        ElevatedButton(
                          child: Text(
                            'Gallery',
                            style: countryCodeGrayText(context),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop(); // Close the dialog
                            getImageFromGallary(openCamera: false);
                          },
                        ),
                      ],
                    )
                  ],
                );
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate_outlined,
                color: MyColors.purple,
              ),
              widthSpace(mediaQuery: mediaQuery, width: 8),
              Text(
                'Add Img',
                style: addImageText(context),
              )
            ],
          ),
        ),
      );
    },
  );
}
