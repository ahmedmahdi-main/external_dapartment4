import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class PickImage {
  static Future<File> pickImage(
    String path,
    ImageSource source,
    String fileName,
  ) async {
    // await getStoragePermission();
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return File(path);
    debugPrint('*-**-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* $path');
    final extension = p.basename(pickedFile.path);
    var pickedFile2 = File(pickedFile.path);
    final newPath = p.join(path, extension);
    File newImage = await pickedFile2.copy(newPath);
    newImage = await changeFileNameOnly(newImage, '$fileName.png');
    return newImage;
  }

  static Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }
}

class ImagePickerService {
  static Future<File?> pickImage(
    String path,
    ImageSource source,
    String fileName,
  ) async {
    // Request storage permission
    await getStoragePermission();

    // Pick an image from the source
    final pickedFile = await ImagePicker().pickImage(source: source);

    // Return null if no image was picked
    if (pickedFile == null) {
      debugPrint('No image selected.');
      return null;
    }

    // Debug print the path
    debugPrint('Picked file path: ${pickedFile.path}');

    // Get the original file
    final pickedFile2 = File(pickedFile.path);

    // Create a new path for the copied image
    final newPath = p.join(path, '$fileName.png'); // Append .png extension

    // Delete the existing file if it exists at the new path
    final existingFile = File(newPath);
    if (await existingFile.exists()) {
      try {
        await existingFile.delete();
        debugPrint('Existing image deleted: $newPath');
      } catch (e) {
        debugPrint('Failed to delete existing image: $e');
        return null; // Return null in case deletion fails to prevent overwriting issues
      }
    }

    // Copy the file to the new path
    try {
      File newImage = await pickedFile2.copy(newPath);
      debugPrint('New image saved at: ${newImage.path}');
      return newImage; // Return the newly created file
    } catch (e) {
      debugPrint('Error copying image: $e');
      return null; // Return null in case of an error
    }
  }

  // This method would be used to request storage permissions
  static Future<void> getStoragePermission() async {
    // Implement permission handling here
  }
}
