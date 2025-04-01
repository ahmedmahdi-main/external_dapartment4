import 'package:flutter/material.dart';

import '../../Services/Colors/Colors.dart';
import '../../Services/Styles/TextStyles.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
      required this.label,
      required this.onTab,
      this.width,
      this.widget});

  final String label;
  final Function() onTab;
  final double? width;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7), color: primaryClr),
        height: 45,
        width: width ?? 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: subHeadingButtonStyle,
                textAlign: TextAlign.center,
              ),
            ),
            widget ?? Container()
          ],
        ),
      ),
    );
  }
}
