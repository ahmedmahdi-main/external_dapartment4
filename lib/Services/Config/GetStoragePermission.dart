import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class WindowsStorage {
  static Future<void> initializeStorage() async {
    await _ensureAppDataDirectory();
  }

  static Future<void> saveImageToAppData() async {
    try {
      // Load the image from assets
      const imagePath = 'Assets/Images/noImageAvailable.png';
      final ByteData bytes = await rootBundle.load(imagePath);
      final imageData = bytes.buffer.asUint8List();

      // Get application data directory
      final appDataDir = await _getAppDataDirectory();
      final imageFile = File(p.join(appDataDir.path, 'noImageAvailable.png'));

      // Ensure directory exists
      if (!await imageFile.parent.exists()) {
        await imageFile.parent.create(recursive: true);
      }

      // Save the image
      await imageFile.writeAsBytes(imageData);
      debugPrint('Image saved to: ${imageFile.path}');
    } catch (e) {
      debugPrint('Error saving image: $e');
    }
  }

  static Future<Directory> _getAppDataDirectory() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    return Directory(p.join(documentsDir.path, 'Museum-library'));
  }

  static Future<void> _ensureAppDataDirectory() async {
    final appDataDir = await _getAppDataDirectory();
    if (!await appDataDir.exists()) {
      await appDataDir.create(recursive: true);
      await _savePathToHive(appDataDir.path);
      await saveImageToAppData();
    }
  }

  static Future<void> createCustomDirectory(String folderName) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final customDir = Directory(p.join(documentsDir.path, folderName));

      if (!await customDir.exists()) {
        await customDir.create(recursive: true);
        debugPrint('Directory created: ${customDir.path}');
        await _savePathToHive(customDir.path);
      } else {
        debugPrint('Directory already exists: ${customDir.path}');
      }
    } catch (e) {
      debugPrint('Error creating directory: $e');
    }
  }

  static Future<void> _savePathToHive(String path) async {
    final box = await _openHiveBox('windowsStorage');
    await box.put('storagePath', path);
  }

  static Future<Box> _openHiveBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      final appDataDir = await getApplicationDocumentsDirectory();
      Hive.init(appDataDir.path);
    }
    return await Hive.openBox(boxName);
  }

  static Future<String?> getStoragePath() async {
    final box = await _openHiveBox('windowsStorage');
    return box.get('storagePath');
  }

  static Future<File> saveFile({
    required String fileName,
    required Uint8List data,
  }) async {
    try {
      final storagePath =
          await getStoragePath() ?? (await _getAppDataDirectory()).path;
      final file = File(p.join(storagePath, fileName));

      await file.writeAsBytes(data);
      return file;
    } catch (e) {
      debugPrint('Error saving file: $e');
      rethrow;
    }
  }

  Future<void> savePathInHive(String path) async {
    var box = await openHiveBox('myBox');
    box.put('storagePath', path);
  }

  static Future<Box> openHiveBox(String boxName) async {
    if (!kIsWeb && !Hive.isBoxOpen(boxName)) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }
    return await Hive.openBox(boxName);
  }
}
