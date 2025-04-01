import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Colors/HexStringToColor.dart';

class TextStyles {}

TextStyle get headingStyle => GoogleFonts.cairo(
    textStyle: TextStyle(
        color: Get.isDarkMode ? Colors.white : Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.w500));

TextStyle get appBarHeadingStyle => GoogleFonts.cairo(
    textStyle: TextStyle(
        color: Get.isDarkMode ? Colors.white : Colors.white,
        fontSize: 27,
        fontWeight: FontWeight.w600));

TextStyle get subHeadingStyle => GoogleFonts.cairo(
    textStyle: TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500));

TextStyle get subHeadingButtonStyle => GoogleFonts.cairo(
    textStyle: TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500));

TextStyle get textEditeGreenStyle => GoogleFonts.amiri(
    textStyle: TextStyle(
        color: !Get.isDarkMode ? hexStringToColor("#085820") : Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600));

TextStyle get textEditeRedStyle => GoogleFonts.amiri(
    textStyle: TextStyle(
        color: Get.isDarkMode ? Colors.red : Colors.redAccent,
        fontSize: 20,
        fontWeight: FontWeight.w600));
