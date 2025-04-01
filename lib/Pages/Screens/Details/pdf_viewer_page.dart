import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerPage extends StatelessWidget {
  const PdfViewerPage({super.key, required this.pdfPath});
  final String pdfPath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("عرض ملف PDF"),
      ),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}
