import 'package:flutter/material.dart';

import '../../Services/Styles/TextStyles.dart';
import 'SizeBox.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    this.widget,
    required this.title,
  });
  final Widget? widget;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget ?? Container(),
        sizeBox(5, 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: subHeadingStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  text,
                  style: subHeadingStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
