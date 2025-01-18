import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:todo_app_task/data/models/toDos_data_model.dart';

bool hidePassword = true;
String userName = '';
String userPhoneNumber = '';
String userPhoneCountryCode = '';
int experienceYears = -1;
String experienceLevel = '';
String address = '';
String password = '';
List experienceLevelItemsName = ['fresh', 'junior', 'midLevel', 'senior'];
final GlobalKey<FormState> registerformkey = GlobalKey<FormState>();
final GlobalKey<FormState> loginformkey = GlobalKey<FormState>();
final GlobalKey<FormState> addTaskformkey = GlobalKey<FormState>();
List<DropdownMenuItem<String>> experienceLevelItems = [
  for (int i = 0; i < experienceLevelItemsName.length; i++)
    DropdownMenuItem<String>(
      value: experienceLevelItemsName[i],
      child: Text(
        experienceLevelItemsName[i],
      ),
    ),
];
bool theFormSubmitted = false;

List<String> statusFourButtonString = [
  'All',
  'Inprogress',
  'Waiting',
  'Finished'
];

List<String> statusFourButtonValues = [
  'All',
  'inprogress',
  'waiting',
  'finished'
];

int statusChossedButtonIndex = 0;

List<ToDosDataModel> statusChoiceResult = [];

int taksDetailsIndex = 0;

final ScrollController scrollController = ScrollController();

int displayedPageOfData = 1;

List<String> profileLabes = [
  'Name',
  'Phone',
  'Level',
  'Years of experience',
  'Location'
];

final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
QRViewController? controller;
bool isCameraActive = false;
bool isScanning = false;

bool taskFormDataSubmitted = false;
String taskTitle = '';
String taskDescription = '';
String taskImage = '';
String taskPriority = '';
DateTime? taskDate;
String displayedTaskDate = '';

List taskPriorityLevelItemsName = ['low', 'medium', 'high'];
final List<Map<String, dynamic>> options = [
  {'value': 'low', 'icon': Icons.flag_outlined},
  {'value': 'medium', 'icon': Icons.flag_outlined},
  {'value': 'high', 'icon': Icons.flag_outlined},
];

List<DropdownMenuItem<String>> taskPriorityLevelItems = [
  for (int i = 0; i < taskPriorityLevelItemsName.length; i++)
    DropdownMenuItem<String>(
      value: taskPriorityLevelItemsName[i],
      child: Text(
        taskPriorityLevelItemsName[i],
      ),
    ),
];

final picker = ImagePicker();

bool navigatingToEditScreen = false;

final TextEditingController editTitleController = TextEditingController();
final TextEditingController editDescriptionController = TextEditingController();
