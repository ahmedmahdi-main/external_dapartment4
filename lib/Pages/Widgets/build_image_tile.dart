import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Screens/Details/full_screen_image_page.dart';

class BuildImageTile extends StatefulWidget {
  const BuildImageTile(
      {super.key, required this.imagePath, required this.onDelete});

  final String imagePath;
  final VoidCallback onDelete;

  @override
  State<BuildImageTile> createState() => _BuildImageTileState();
}

class _BuildImageTileState extends State<BuildImageTile> {
  bool _isDeleteVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => FullScreenImagePage(imagePath: widget.imagePath));
      },
      onLongPress: () {
        setState(() {
          _isDeleteVisible = true;
        });
      },
      onDoubleTap: () {
        setState(() {
          _isDeleteVisible = false;
        });
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: File(widget.imagePath).existsSync()
                  ? Hero(
                      tag: widget.imagePath,
                      child: Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : Center(
                      child: Text(
                        'لا توجد صورة',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
            ),
          ),
          if (_isDeleteVisible)
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  widget.onDelete();
                  setState(() {
                    _isDeleteVisible = false;
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
