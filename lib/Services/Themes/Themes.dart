import 'package:flutter/material.dart';

import '../Colors/Colors.dart';

class Themes {
  static final light = ThemeData(
      primaryColor: primaryClr,
      scaffoldBackgroundColor: tealColor,
      brightness: Brightness.light);

  static final dark = ThemeData(
      primaryColor: darkGreyClr,
      scaffoldBackgroundColor: tealColor,
      brightness: Brightness.dark);
}
