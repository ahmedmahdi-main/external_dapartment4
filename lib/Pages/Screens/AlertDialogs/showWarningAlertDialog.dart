import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Services/Styles/TextStyles.dart';

showAlertDialog(BuildContext context,
    {String message = 'يرجى ملئ الحقول اولا'}) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text('حسنا'),
    onPressed: () {
      Get.back();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(
        child: Text(
      'خطا',
      style: textEditeRedStyle,
    )),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
