import 'dart:io';

import 'package:external_dapartment4/Pages/Screens/Details/pdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../Controllers/BookController.dart';
import '../../../Models/Book.dart';
import '../../../Services/Colors/Colors.dart';
import '../../../Services/SnackBars/Snackbars.dart';
import '../../Widgets/MyButton.dart';
import '../../Widgets/MyLiquidLinearProgressIndicator.dart';
import '../../Widgets/MySliverAppBar.dart';
import '../../Widgets/SizeBox.dart';
import '../../Widgets/TextWidget.dart';
import '../../Widgets/build_image_tile.dart';
import '../AlertDialogs/showWarningAlertDialog.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  static const String routeName = 'DetailsPage';

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final bookId = int.parse(Get.arguments['bookId'].toString());
  Book? book = Book();
  RxString path = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return [createImageSilverAppBar('background2', 190)];
          },
          body: GetBuilder<BookController>(
            init: BookController(),
            builder: (controller) {
              if (controller.isLoading.value) {
                return const MyLiquidLinearProgressIndicator();
              }
              book = controller.bookList.firstWhere(
                (p0) => p0.id == bookId,
                orElse: () => Book(),
              );
              path.value = book!.title!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:
                        MainAxisSize.max, // Use max to fill the available space
                    children: [
                      sizeBox(5, 0.0),
                      TextWidget(
                        title: 'عنوان الكتاب: ',
                        text:
                            book?.title != null
                                ? '${book?.title!}'
                                : 'غير معروف',
                        widget: Icon(Icons.book_rounded, color: primaryClr),
                      ),
                      sizeBox(16, 5),
                      TextWidget(
                        title: ' رقم الكتاب : ',
                        text:
                            book?.number != null
                                ? '${book!.number}'
                                : 'غير معروف ',
                        widget: Icon(
                          Icons.format_list_numbered,
                          color: primaryClr,
                        ),
                      ),
                      sizeBox(16, 5),
                      TextWidget(
                        title: 'تاريخ الكتاب : ',
                        text:
                            book?.date != null
                                ? DateFormat('dd-MM-yyyy').format(book!.date!)
                                : 'غير معروف ',
                        widget: Icon(Icons.date_range, color: primaryClr),
                      ),
                      sizeBox(16, 0),
                      TextWidget(
                        title: 'هامش المتولي: ',
                        text:
                            book?.mutawalliMargin != null
                                ? '${book?.mutawalliMargin!}'
                                : ' : غير معروف',
                        widget: Icon(Icons.pie_chart, color: primaryClr),
                      ),
                      sizeBox(16, 0),
                      TextWidget(
                        title: 'هامش الامين العام: ',
                        text:
                            book?.aminMargin != null
                                ? '${book?.aminMargin!}'
                                : 'غير معروف',
                        widget: Icon(Icons.yard, color: primaryClr),
                      ),
                      sizeBox(16, 0),
                      TextWidget(
                        title: 'المتابعة: ',
                        text:
                            book?.followup != null
                                ? '${book?.followup!}'
                                : ' : لا يوجد',
                        widget: Icon(Icons.note, color: primaryClr),
                      ),
                      sizeBox(16, 0),
                      TextWidget(
                        title: 'الاجراء: ',
                        text:
                            book?.procedure != null
                                ? '${book?.procedure!}'
                                : ' : لا يوجد',
                        widget: Icon(Icons.approval_sharp, color: primaryClr),
                      ),
                      sizeBox(16, 0),
                      TextWidget(
                        title: 'الملاحظات:',
                        text:
                            book?.notes != null
                                ? '${book?.notes!}'
                                : ' الملاحظات : لا يوجد',
                        widget: Icon(Icons.note, color: primaryClr),
                      ),
                      sizeBox(16, 0),
                      book!.imagePaths.isNotEmpty
                          ? GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of columns
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                ),
                            itemCount: book?.imagePaths.length,
                            itemBuilder: (context, index) {
                              String? imagePath = book?.imagePaths[index];
                              return BuildImageTile(
                                imagePath: imagePath ?? '',
                                onDelete: () async {
                                  await _deleteImage(imagePath!);
                                },
                              );
                            },
                          )
                          : Center(
                            child: Text(
                              'لا توجد صور',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      sizeBox(16, 0),
                      Center(
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: MyButton(
                                label: 'كامرة',
                                onTab: () async {
                                  if (book!.title!.isEmpty) {
                                    await showAlertDialog(context);
                                  } else {
                                    PaintingBinding.instance.imageCache.clear();
                                    await controller.pickAndSaveImage(
                                      ImageSource.camera,
                                      book!,
                                    );
                                    controller.update();
                                    PaintingBinding.instance.imageCache.clear();
                                  }
                                },
                                width: double.infinity,
                                widget: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: MyButton(
                                label: 'الاستوديو',
                                onTab: () async {
                                  if (book!.title!.isEmpty) {
                                    await showAlertDialog(context);
                                  } else {
                                    PaintingBinding.instance.imageCache.clear();
                                    await controller.pickAndSaveImage(
                                      ImageSource.gallery,
                                      book!,
                                    );
                                    controller.update();
                                    PaintingBinding.instance.imageCache.clear();
                                  }
                                },
                                width: double.infinity,
                                widget: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.image, color: Colors.white),
                                ),
                              ),
                            ),
                            MyButton(
                              label: '',
                              onTab: () async {
                                PaintingBinding.instance.imageCache.clear();
                                controller.update();
                              },
                              width: 50,
                              widget: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      MyButton(
                        label: 'عرض الملف PDF',
                        onTab: () async {
                          _viewPdf();
                        },
                        width: double.infinity,
                        widget: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
}
