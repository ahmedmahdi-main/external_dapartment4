import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Services/Colors/Colors.dart';
import '../../Services/Config/SizeConfig.dart';
import '../../Services/Styles/TextStyles.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget,
      this.readOnly});

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final bool? readOnly;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.only(right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: subHeadingStyle,
          ),
          Container(
            width: SizeConfig.screenWidth,
            height: 50,
            // padding: const EdgeInsets.only(top: 18),
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  width: 2,
                  color: Get.isDarkMode ? primaryClr : darkGreyClr,
                  style: BorderStyle.solid),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    cursorColor: Get.isDarkMode ? primaryClr : darkGreyClr,
                    controller: controller,
                    style: subHeadingStyle.copyWith(fontSize: 12),
                    autofocus: true,
                    readOnly: readOnly ?? false,
                    decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subHeadingStyle.copyWith(fontSize: 14),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.colorScheme.background,
                                width: 0))),
                  ),
                ),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
