import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imagePath;

  const FullScreenImagePage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black, // Set the background to black for better contrast
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Back arrow color
      ),
      body: Center(
        child: Hero(
          tag: imagePath,
          child: File(imagePath).existsSync()
              ? Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                )
              : Center(
                  child: Text(
                    'لا توجد صورة',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
        ),
      ),
    );
  }
}
