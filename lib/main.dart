import 'dart:io';

import 'package:external_dapartment4/Data/InitDatabase.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'Pages/Screens/Main/MainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite_common_ffi for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit(); // Initialize FFI
    databaseFactory = databaseFactoryFfi; // Set the database factory
  }

  await InitDatabase.initDatabase();
  await createFolderInDocuments('External-Locations');
  runApp(const MainPage());
}

Future<void> createFolderInDocuments(String folderName) async {
  if (!Platform.isWindows) {
    throw Exception('This function is only supported on Windows');
  }

  final userProfile = Platform.environment['USERPROFILE'];
  if (userProfile == null) {
    throw Exception('USERPROFILE environment variable not found');
  }

  final documentsPath = Directory('$userProfile\\Documents');
  final folderPath = Directory('${documentsPath.path}\\$folderName');

  if (!(await documentsPath.exists())) {
    throw Exception('Documents directory does not exist');
  }

  if (!(await folderPath.exists())) {
    await folderPath.create(recursive: true);
  }
}
