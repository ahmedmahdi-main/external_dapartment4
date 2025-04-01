import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Services/Colors/GetColorsByMode.dart';
import '../../../Services/Config/GetStoragePermission.dart';
import '../../../Services/PickImage/pickImage.dart';
import '../../../Services/Styles/TextStyles.dart';

enum DialogsAction { yes, no, cancel }

class CameraGalleryImages {
  static Future<String> getPathFromHive() async {
    var box = await WindowsStorage.openHiveBox('myBox');
    return box.get('storagePath');
  }

  static Future<DialogsAction> yesNoDialog(
    BuildContext context,
    String title,
    int bookId,
  ) async {
    String path = await getPathFromHive();
    final action = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 0,
          title: Text(title),
          content: Text(bookId.toString()),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GFButton(
                  textStyle: subHeadingStyle.copyWith(
                    color: getColorByMode(),
                    fontSize: 14,
                  ),
                  text: 'معرض الصور',
                  onPressed: () async {
                    if (path.isEmpty) return;
                    await PickImage.pickImage(path, ImageSource.gallery, title);

                    // _imagesOperation.itemCount ++;

                    // getImages();
                    // SnackBars().snackBarSuccess('تم الحفظ', "");
                  },
                  icon: const Icon(Icons.image_search),
                  color: getColorByMode(),
                  type: GFButtonType.outline,
                  size: GFSize.LARGE,
                  shape: GFButtonShape.pills,
                ),
                const SizedBox(width: 24),
                GFButton(
                  text: "كامرة",
                  textStyle: subHeadingStyle.copyWith(
                    color: getColorByMode(),
                    fontSize: 14,
                  ),
                  onPressed: () async {
                    await PickImage.pickImage(path, ImageSource.camera, title);
                  },
                  shape: GFButtonShape.pills,
                  icon: const Icon(
                    Icons.camera,
                    // size: 85,
                  ),
                  color: getColorByMode(),
                  type: GFButtonType.outline,
                  size: GFSize.LARGE,
                ),
              ],
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogsAction.cancel;
  }
}
