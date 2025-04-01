import 'package:flutter/material.dart';
import '../Services/Colors/Colors.dart';

class StyledText extends StatelessWidget {
  final String text;

  const StyledText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, color: primaryClr),
    );
  }
}
