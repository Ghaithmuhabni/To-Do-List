import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/utils/app_str.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

String lottieURL = 'assets/lottie/1.json';

dynamic emptyWarning(BuildContext context) {
  return FToast.toast(context,
      msg: MyString.opssMsg,
      subMsg: 'You Must fill all fields!',
      corner: 20.0,
      duration: 2000,
      padding: EdgeInsets.all(20));
}

dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(context,
      msg: MyString.opssMsg,
      subMsg: 'You Must edit the tasks then try to update it!',
      corner: 20.0,
      duration: 3000,
      padding: EdgeInsets.all(20));
}

dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(context,
      title: MyString.opssMsg,
      message:
          "There is no task For Delete!\n Try adding some and then try to delete it!",
      buttonText: "Okay", onTapDismiss: () {
    Navigator.pop(context);
  }, panaraDialogType: PanaraDialogType.warning);
}

dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(context,
      title: MyString.areYousure,
      message:
          "Do You really want to delete all tasks? You will no be able to undo this action!",
      confirmButtonText: 'Yes',
      cancelButtonText: 'No', onTapConfirm: () {
    BaseWidget.of(context).dataStore.box.clear();
    Navigator.pop(context);
  }, onTapCancel: () {
    Navigator.pop(context);
  }, panaraDialogType: PanaraDialogType.error);
}
