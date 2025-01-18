import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_task/constants/colors.dart';
import 'package:todo_app_task/presentation/widgets/app_widgets.dart';

largBlackText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 31.25 / 24, //Desired Height ÷ Font Size
      color: MyColors.largBlackText,
    ),
  );
}

smallGrayText({required BuildContext context, required blackColor}) {
  return GoogleFonts.dmSans(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 24 / 14, //Desired Height ÷ Font Size
      color: (blackColor) ? MyColors.largBlackText : MyColors.smallGrayText,
    ),
  );
}

errorRedText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 13,
      color: Colors.red,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

// ignore: non_constant_identifier_names
WhiteText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w700,
      height: 24.74 / 19, //Desired Height ÷ Font Size
      color: MyColors.white,
    ),
  );
}

hintTextField(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.2,
      height: 20 / 14, //Desired Height ÷ Font Size
      color: MyColors.textFieldHintText,
    ),
  );
}

dropDownHintText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 14,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      height: 20 / 14, //Desired Height ÷ Font Size
      color: MyColors.blackColorForDropDownMenu,
    ),
  );
}

dropDownPriorityDefaultHintText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 16,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      height: 20 / 16, //Desired Height ÷ Font Size
      color: MyColors.blackColorForDropDownMenu,
    ),
  );
}

signInAndSignUpButton(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 14,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      height: 20 / 14, //Desired Height ÷ Font Size
      color: MyColors.purple,
      decoration: TextDecoration.underline,
    ),
  );
}

countryCodeGrayText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 14,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w700,
      height: 20 / 14, //Desired Height ÷ Font Size
      color: MyColors.textFieldHintText,
    ),
  );
}

myTasksLableText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 20.83 / 16, //Desired Height ÷ Font Size
      color: MyColors.largBlackText,
    ),
  );
}

statusButtonsText({required BuildContext context, required chossedButton}) {
  return GoogleFonts.dmSans(
    textStyle: TextStyle(
      fontSize: 16,
      overflow: TextOverflow.ellipsis,
      fontWeight: (chossedButton) ? FontWeight.w700 : FontWeight.w400,
      height: 20 / 16, //Desired Height ÷ Font Size
      letterSpacing: 0.2,
      color: (chossedButton) ? MyColors.white : MyColors.textFieldHintText,
    ),
  );
}

statusLableText({required BuildContext context, required status}) {
  return GoogleFonts.dmSans(
    textStyle: TextStyle(
      fontSize: 12,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      height: 18 / 12, //Desired Height ÷ Font Size
      color: (status == 'waiting')
          ? MyColors.statusWatingTextColor
          : (status == 'inprogress')
              ? MyColors.statusInprogressTextColor
              : MyColors.statusFinishedTextColor,
    ),
  );
}

priorityLableText({required BuildContext context, required priority}) {
  return GoogleFonts.dmSans(
    textStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      height: 18 / 12, //Desired Height ÷ Font Size
      color: (priority == 'low')
          ? MyColors.statusFinishedTextColor
          : (priority == 'medium')
              ? MyColors.statusInprogressTextColor
              : MyColors.statusWatingTextColor,
    ),
  );
}

popupMenuButtonText({required BuildContext context, required delete}) {
  return GoogleFonts.dmSans(
    textStyle: TextStyle(
      fontSize: 16,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      height: 24 / 16, //Desired Height ÷ Font Size
      color: (delete == true)
          ? MyColors.statusWatingTextColor
          : MyColors.blackColorForDropDownMenu,
    ),
  );
}

toDosListEndText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 18,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      height: 18 / 18, //Desired Height ÷ Font Size
      color: MyColors.statusWatingTextColor,
    ),
  );
}

profileDataLableText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 12,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      height: 16 / 12, //Desired Height ÷ Font Size
      letterSpacing: 0.2,
      color: MyColors.blackColorForDropDownMenu,
    ),
  );
}

profileDataText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 18,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w700,
      height: 24 / 18, //Desired Height ÷ Font Size
      letterSpacing: 0.2,
      color: MyColors.blackColorForDropDownMenu,
    ),
  );
}

taskDetailsLableText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 9,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w400,
      height: 12 / 9, //Desired Height ÷ Font Size
      color: MyColors.smallGrayText,
    ),
  );
}

taskDetailsDataText(
    {required BuildContext context,
    required isItStatus,
    required status,
    required priority}) {
  return GoogleFonts.dmSans(
    textStyle: TextStyle(
      fontSize: 16,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w700,
      height: 20 / 16, //Desired Height ÷ Font Size
      letterSpacing: 0.2,
      color: (isItStatus)
          ? statusColor(status: status, background: false)
          : priorityColor(priority: priority, background: false),
    ),
  );
}

addImageText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 19,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      height: 25 / 19, //Desired Height ÷ Font Size
      color: MyColors.purple,
    ),
  );
}

addNewTaskLabalsText(BuildContext context) {
  return GoogleFonts.dmSans(
    textStyle: const TextStyle(
      fontSize: 12,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w400,
      height: 18 / 12, //Desired Height ÷ Font Size
      color: MyColors.smallGrayText,
    ),
  );
}
