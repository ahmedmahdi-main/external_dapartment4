

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Colors/Colors.dart';
import '../Styles/TextStyles.dart';

class SnackBars {
  void snackBarSuccess(String lable, String details) {
    Get.snackbar('', '',
        colorText: pinkClr,
        backgroundColor: Get.isDarkMode ? Colors.grey[20] : Colors.green[20],
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          lable,
          style: textEditeGreenStyle,
          textAlign: TextAlign.right,
        ),
        messageText: Text(
          details,
          style: textEditeGreenStyle,
          textAlign: TextAlign.right,
        ),
        icon: const Icon(
          Icons.save,
          color: Colors.blueGrey,
          size: 55,
        ));
  }

  void snackBarFail(String lable, String details) {
    Get.snackbar('', '',
        colorText: pinkClr,
        backgroundColor: Get.isDarkMode ? Colors.red[250] : Colors.red[100],
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          lable,
          style: textEditeRedStyle,
          textAlign: TextAlign.right,
        ),
        messageText: Text(
          details,
          style: textEditeRedStyle,
          textAlign: TextAlign.right,
        ),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
          size: 55,
        ));
  }
}
