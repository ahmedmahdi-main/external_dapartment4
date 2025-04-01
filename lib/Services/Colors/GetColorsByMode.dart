import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Colors.dart';

Color getColorByMode(){
  return Get.isDarkMode
      ? darkHeaderClr
      : darkGreyClr;
}