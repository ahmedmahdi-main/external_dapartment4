import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Services/Colors/Colors.dart';
import '../../Services/Styles/TextStyles.dart';
import '../../Services/Themes/ThemeServices.dart';

AppBar myAppBar() {
  return AppBar(
    elevation: 0,
    leading: IconButton(
      onPressed: () {
        ThemeServices().switchTheme();
      },
      icon: Get.isDarkMode
          ? const Icon(Icons.dark_mode)
          : const Icon(Icons.light_mode),
    ),
    backgroundColor: Get.isDarkMode ? primaryClr : darkGreyClr,
    title: Center(
        child: Text(
      'مكتبة متحف الكفيل',
      style: appBarHeadingStyle,
    )),
  );
}
