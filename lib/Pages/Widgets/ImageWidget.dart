import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path/path.dart'; // Required for 'join'

import '../../Controllers/BookController.dart'; // Assuming GFImageOverlay is from getwidget package

class ImageWidget extends StatelessWidget {
  ImageWidget({super.key, required this.imageName});

 final String imageName;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookController(), permanent: true);

    // Ensure the path is ready
    if (controller.path.value.isNotEmpty) {
      // Construct the full image path using the provided image name and the path from Hive
      String fullImagePath = join(controller.path.value, '$imageName.png');

      return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.theme.primaryColor, width: 2),
        ),
        child: Center(
          child: File(fullImagePath).existsSync()
              ? GFImageOverlay(
                  height: 500,
                  width: double.infinity,
                  image: FileImage(File(fullImagePath)),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.darken),
                )
              : Text(
                  'لا توجد صورة',
                  style: TextStyle(color: context.theme.primaryColor),
                ),
        ),
      );
    } else {
      // Display a loading indicator while waiting for the path to be ready
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
