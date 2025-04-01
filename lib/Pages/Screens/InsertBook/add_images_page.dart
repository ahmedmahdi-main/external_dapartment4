import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Controllers/BookController.dart';
import '../../../Models/Book.dart';
import '../../../Services/Colors/Colors.dart';
import '../../../Services/Config/SizeConfig.dart';
import '../../../Services/SnackBars/Snackbars.dart';
import '../../Widgets/MyButton.dart';
import '../../Widgets/build_image_tile.dart';
import '../Details/pdf_viewer_page.dart';

class AddImagesPage extends StatefulWidget {
  const AddImagesPage({Key? key}) : super(key: key);

  static const String routeName = 'AddImages';

  @override
  State<AddImagesPage> createState() => _AddImagesPageState();
}

class _AddImagesPageState extends State<AddImagesPage> {
  final int bookId = int.parse(Get.arguments['bookId'].toString());
  final BookController bookController = Get.put(BookController());
  Book? book;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await bookController.getAllBooks();
      book = bookController.bookList.firstWhereOrNull((p0) => p0.id == bookId);
      setState(() {}); // Refresh the UI once the book is retrieved
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: darkGreyClr,
        title: Center(
            child: Text(
          'إضافة الصور',
          style: TextStyle(fontSize: 20, color: Colors.white),
        )),
      ),
      body: book == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    book!.imagePaths.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: book!.imagePaths.length,
                            itemBuilder: (context, index) {
                              String imagePath = book!.imagePaths[index];
                              return BuildImageTile(
                                imagePath: imagePath,
                                onDelete: () async {
                                  await _deleteImage(imagePath);
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'لا توجد صور',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                    Row(children: [
                      Flexible(
                        flex: 1,
                        child: MyButton(
                            label: 'كامرة',
                            onTab: () async {
                              await _pickAndSaveImage(ImageSource.camera);
                            },
                            width: SizeConfig.screenWidth,
                            widget: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                            )),
                      ),
                      Flexible(
                        child: MyButton(
                            label: 'الاستوديو',
                            onTab: () async {
                              await _pickAndSaveImage(ImageSource.gallery);
                            },
                            width: SizeConfig.screenWidth,
                            widget: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ]),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: MyButton(
                            label: 'إضافة ملف PDF',
                            onTab: () async {
                              await bookController.pickAndSavePdf(book!);
                            },
                            width: SizeConfig.screenWidth,
                            widget: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: MyButton(
                            label: 'عرض ملف PDF',
                            onTab: () async {
                              _viewPdf();
                            },
                            width: SizeConfig.screenWidth,
                            widget: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    MyButton(
                      label: 'حفظ ',
                      onTab: () async {
                        try {
                          await bookController.updateBook(book!);
                          SnackBars().snackBarSuccess('تم حفظ  بنجاح', '');
                          Get.offAllNamed('/BooksList');
                        } on Exception catch (e) {
                          SnackBars().snackBarFail('هنالك مشكلة', e.toString());
                        }
                      },
                      width: SizeConfig.screenWidth,
                      widget: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Icon(
                          Icons.save_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _deleteImage(String imagePath) async {
    if (book == null) return;

    try {
      // Remove the image path from the book's imagePaths list
      book!.imagePaths.remove(imagePath);

      // Update the database to save changes
      await Get.find<BookController>().updateBook(book!);

      // Delete the image file from storage if necessary
      File file = File(imagePath);
      if (file.existsSync()) {
        file.deleteSync();
      }

      setState(() {}); // Refresh the UI
    } catch (e) {
      SnackBars().snackBarFail('حدث خطأ أثناء حذف الصورة', e.toString());
    }
  }

  void _viewPdf() {
    if (book == null || book!.pdfPath == null) {
      SnackBars().snackBarFail('لا يوجد ملف PDF للعرض', '');
      return;
    }

    // Navigate to the PDF viewer
    Get.to(() => PdfViewerPage(pdfPath: book!.pdfPath!));
  }

  Future<void> _pickAndSaveImage(ImageSource source) async {
    if (book == null) return;
    try {
      await bookController.pickAndSaveImage(source, book!);
      setState(() {}); // Refresh the UI to show the new image
    } catch (e) {
      SnackBars().snackBarFail('هنالك مشكلة في حفظ الصورة', e.toString());
    }
  }
}
