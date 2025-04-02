import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart'; // For platform checks
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Import the PDF viewer package

import '../../../Controllers/BookController.dart';
import '../../../Models/Book.dart';
import '../../../Services/Colors/Colors.dart';
import '../../../Services/Colors/HexStringToColor.dart';
import '../../../Services/SnackBars/Snackbars.dart';
import '../../Widgets/MyGFListTile.dart';
import '../../Widgets/MyLiquidLinearProgressIndicator.dart';
import '../../Widgets/MySliverAppBar.dart';
import '../../Widgets/NoBooksWidget.dart';
import '../AlertDialogs/AlertDialog.dart';
import '../../../Widgets/StyledText.dart'; // Import the new StyledText widget

class BooksList extends StatelessWidget {
  const BooksList({super.key});

  static const String routeName = 'BooksList';

  @override
  Widget build(BuildContext context) {
    final BookController bookController = Get.put(BookController());

    return Scaffold(
      body: Obx(() {
        if (bookController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return kIsWeb || defaultTargetPlatform == TargetPlatform.windows
            ? Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: hexStringToColor('006A71').withAlpha(10),
                      child: _buildSidebar(bookController),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: _buildMainContent(bookController),
                  ),
                ],
              )
            : _buildMobileLayout(bookController);
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.isDarkMode ? darkGreyClr : primaryClr,
        onPressed: () async {
          await Get.toNamed('/InsertBook', arguments: {'bookId': 0});
          bookController.getAllBooks(); // Refresh the book list
        },
        tooltip: 'اضافة كتاب جديد',
        child: const Icon(
          Icons.add,
          size: 45,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSidebar(BookController bookController) {
    RxString searchQuery = ''.obs;

    return Obx(() {
      var filteredBooks = bookController.bookList.where((book) {
        return (book.title?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
            (book.number?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);
      }).toList();

      return Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'قائمة الكتب',
                style: TextStyle(fontSize: 24.5, fontWeight: FontWeight.bold, color: primaryClr),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryClr,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${bookController.bookList.length}', // Display the count of books
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              onChanged: (value) {
                searchQuery.value = value; // Update the search query
              },
              decoration: InputDecoration(
                hintText: 'بحث بالعنوان أو الرقم...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                var book = filteredBooks[index];
                return GestureDetector(
                  onTap: () {
                    bookController.selectedBook.value = book; // Update the selected book
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Get.isDarkMode ? hexStringToColor('F2EFE7') : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.book, color: Colors.blue),
                                  const SizedBox(width: 10),
                                  StyledText(text: 'العنوان: ${book.title ?? 'لا يوجد عنوان'}'),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Get.toNamed('/InsertBook', arguments: {'bookId': book.id});
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await _confirmAndDeleteBook(bookController, book);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          StyledText(text: 'رقم: ${book.number ?? 'لا يوجد رقم'}'),
                          StyledText(text: 'التاريخ: ${book.date?.toLocal().toString().split(' ')[0] ?? 'لا يوجد تاريخ'}'),
                          StyledText(text: 'هامش الأمين: ${book.aminMargin ?? 'لا يوجد هامش'}'),
                          StyledText(text: 'هامش المتولي: ${book.mutawalliMargin ?? 'لا يوجد هامش'}'),
                          StyledText(text: 'المتابعة: ${book.followup ?? 'لا يوجد متابعة'}'),
                          StyledText(text: 'الإجراء: ${book.procedure ?? 'لا يوجد إجراء'}'),
                          StyledText(text: 'ملاحظات: ${book.notes ?? 'لا يوجد ملاحظات'}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
        ],
      );
    });
  }

  Future<void> _confirmAndDeleteBook(BookController bookController, Book book) async {
    var result = await AlertDialogs.yesNoDialog(
        Get.context!, 'حذف الكتاب', 'هل تريد تأكيد حذف الكتاب "${book.title}"؟');
    if (result == DialogsAction.yes) {
        try {
            // Delete associated files
            if (book.pdfPath != null && book.pdfPath!.isNotEmpty) {
                File pdfFile = File(book.pdfPath!);
                if (await pdfFile.exists()) {
                    await pdfFile.delete();
                }
            }
            for (String imagePath in book.imagePaths) {
                File imageFile = File(imagePath);
                if (await imageFile.exists()) {
                    await imageFile.delete();
                }
            }

            // Delete the book from the database
            await bookController.deleteBook(book);
            SnackBars().snackBarSuccess('تم حذف الكتاب بنجاح', '');
        } catch (e) {
            SnackBars().snackBarFail('حدث خطأ أثناء حذف الكتاب', e.toString());
        }
    }
}

  Widget _buildMainContent(BookController bookController) {
    return Obx(() {
      var book = bookController.selectedBook.value;
      if (book == null) {
        return Center(
          child: StyledText(text: 'يرجى اختيار كتاب من القائمة لعرض الملفات.'),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed header section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200], // Optional background color for the header
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledText(text: 'العنوان: ${book.title ?? 'لا يوجد عنوان'}'),
                StyledText(
                  text: 'عدد الصور: ${book.imagePaths.length}', // Display the count of images
                ),
              ],
            ),
          ),
          const Divider(), // Optional divider between header and content
          // Scrollable content section
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (book.pdfPath != null && book.pdfPath!.isNotEmpty)
                      SizedBox(
                        height: 600, // Set a fixed height for the PDF viewer
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed('/PdfViewer', arguments: {'pdfPath': book.pdfPath});
                          },
                          child: Card(
                            elevation: 4,
                            clipBehavior: Clip.antiAlias, // Ensure the content fits within the card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SfPdfViewer.file(
                              File(book.pdfPath!), // Render the PDF file
                              canShowScrollHead: false,
                              canShowScrollStatus: false,
                              enableDoubleTapZooming: false,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (book.imagePaths.isNotEmpty)
                      StyledText(text: 'الصور:'),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true, // Allow GridView to shrink to fit its content
                      physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1, // Ensure square cells
                      ),
                      itemCount: book.imagePaths.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            debugPrint('Opening Image: ${book.imagePaths[index]}');
                          },
                          child: Card(
                            color: Get.isDarkMode ? hexStringToColor('F2EFE7') : Colors.white,
                            elevation: 4,
                            clipBehavior: Clip.antiAlias, // Ensure the image fits within the card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.file(
                              File(book.imagePaths[index]),
                              fit: BoxFit.contain, // Ensure the image covers the entire cell
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, color: Colors.grey);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildMobileLayout(BookController bookController) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
        return <Widget>[
          createImageSilverAppBar('background', 190),
          createSilverAppBar2(),
        ];
      },
      body: Obx(() {
        if (bookController.isLoading.value) {
          return const MyLiquidLinearProgressIndicator();
        }
        if (bookController.bookList.isEmpty) {
          return const NoBooksMsg();
        }
        return ListView.builder(
          controller: ScrollController(),
          itemCount: bookController.bookList.length,
          itemBuilder: (BuildContext context, int index) {
            var book = bookController.bookList[index];
            return Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: ((context) async {
                      await _confirmAndDeleteBook(bookController, book);
                    }),
                    backgroundColor: hexStringToColor('A31118'),
                    icon: Icons.delete,
                    label: 'حذف',
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    padding: const EdgeInsets.all(15),
                    spacing: 15,
                  )
                ],
              ),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: ((context) {
                      Get.toNamed('/InsertBook', arguments: {'bookId': book.id});
                    }),
                    backgroundColor: darkGreyClr,
                    icon: Icons.edit,
                    label: 'تعديل',
                    autoClose: true,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    padding: const EdgeInsets.all(15),
                    spacing: 25,
                  )
                ],
              ),
              child: MyGFListTile(
                book: book,
              ),
            );
          },
        );
      }),
    );
  }

  SliverAppBar createSilverAppBar2() {
    return SliverAppBar(
      backgroundColor: hexStringToColor('006A71').withAlpha(125),
      pinned: true,
      automaticallyImplyLeading: false,
      title: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: CupertinoTextField(
                onChanged: (input) async {
                  await Get.find<BookController>().getBooksByTitleOrAuthor(input);
                },
                keyboardType: TextInputType.text,
                placeholder: 'بحث',
                placeholderStyle: TextStyle(
                  color: primaryClr,
                  fontSize: 14.0,
                  fontFamily: 'Brutal',
                ),
                prefix: const Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                  child: Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
