import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

enum DialogsAction {
  yes,
  no,
  cancel,
}

class AlertDialogs {
  static Future<DialogsAction> yesNoDialog(
      BuildContext context,
      String title,
      String body,
      ) async {
    final action = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 0,
            title: Text(title),
            content: Text(body),
            actions: [
              GFButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'الغاء',
                color: Colors.green,
              ),
              GFButton(
                onPressed: () {
                  Navigator.of(context).pop(DialogsAction.yes);
                },
                text: 'حذف',
                color: Colors.red,
              ),
            ],
          );
        });
    return (action != null) ? action : DialogsAction.cancel;
  }
}
