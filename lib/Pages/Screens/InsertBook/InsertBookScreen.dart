import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Controllers/BookController.dart';
import '../../../Models/Book.dart';
import '../../../Services/Colors/Colors.dart';
import '../../../Services/Config/SizeConfig.dart';
import '../../../Services/SnackBars/Snackbars.dart';
import '../../../Services/Styles/TextStyles.dart';
import '../../Widgets/InputField.dart';
import '../../Widgets/MyButton.dart';
import '../../Widgets/MyLiquidLinearProgressIndicator.dart';

class InsertBook extends StatefulWidget {
  const InsertBook({super.key});

  static const String routeName = 'InsertBook';

  @override
  State<InsertBook> createState() => _InsertBookState();
}

class _InsertBookState extends State<InsertBook> {
  final bookId = int.parse(Get.arguments['bookId'].toString());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController aminMarginController = TextEditingController();
  final TextEditingController mutawalliMarginController =
      TextEditingController();
  final TextEditingController followupController = TextEditingController();
  final TextEditingController procedureController = TextEditingController();

  final BookController bookController = Get.put(BookController());

  Book? book;
  String path = '';
  RxString imageName = ''.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration.zero, () async {
        await bookController.getAllBooks();
        if (bookId != 0) {
          book = bookController.bookList.firstWhereOrNull((p0) => p0.id == bookId);
          if (book != null) {
            setBookData();
          }
        } else {
          book = Book(id: 0);
        }
        setState(() {}); // Refresh the UI
      });
    });
  }

  void setBookData() {
    titleController.text = book?.title ?? '';
    imageName.value = book?.title ?? '';
    numberController.text = book?.number ?? '';
    DateTime? date = book?.date; // Assuming book?.date is a DateTime object
    dateController.text =
        date != null ? DateFormat('yyyy-MM-dd').format(date) : '';
    aminMarginController.text = book?.aminMargin ?? '';
    mutawalliMarginController.text = book?.mutawalliMargin ?? '';
    followupController.text = book?.followup ?? '';
    procedureController.text = book?.procedure ?? '';
    notesController.text = book?.notes ?? '';
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
          'قسم المواقع الخارجية',
          style: appBarHeadingStyle,
        )),
      ),
      body: GetBuilder<BookController>(
          init: BookController(),
          builder: (controller) {
            if (controller.isLoading.value) {
              return const MyLiquidLinearProgressIndicator();
            }
            // Prevent null-related errors by ensuring `book` is initialized
            if (book == null) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  InputField(
                    title: 'عنوان الكتاب',
                    hint: '',
                    controller: titleController,
                    widget: Icon(
                      Icons.book_rounded,
                      color: primaryClr,
                    ),
                  ),
                  InputField(
                    title: 'رقم الكتاب',
                    hint: '',
                    controller: numberController,
                    widget: Icon(
                      Icons.format_list_numbered,
                      color: primaryClr,
                    ),
                  ),
                  InputField(
                    title: 'التاريخ',
                    hint: '',
                    controller: dateController,
                    widget: GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          // Format and set the date in the controller
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            dateController.text = formattedDate;
                          });
                        }
                      },
                      child: Icon(
                        Icons.calendar_today,
                        color: primaryClr,
                      ),
                    ),
                  ),
                  InputField(
                    title: 'هامش الأمين',
                    hint: '',
                    controller: aminMarginController,
                    widget: Icon(
                      Icons.margin,
                      color: primaryClr,
                    ),
                  ),
                  InputField(
                    title: 'هامش المتولي',
                    hint: '',
                    controller: mutawalliMarginController,
                    widget: Icon(
                      Icons.edit_note,
                      color: primaryClr,
                    ),
                  ),
                  InputField(
                    title: 'المتابعة',
                    hint: '',
                    controller: followupController,
                    widget: Icon(
                      Icons.follow_the_signs,
                      color: primaryClr,
                    ),
                  ),
                  InputField(
                    title: 'الإجراءات',
                    hint: '',
                    controller: procedureController,
                    widget: Icon(
                      Icons.work_outline,
                      color: primaryClr,
                    ),
                  ),
                  InputField(
                    title: 'الملاحظات',
                    hint: '',
                    controller: notesController,
                    widget: Icon(
                      Icons.note,
                      color: primaryClr,
                    ),
                  ),
                  // Row(children: [
                  //   Flexible(
                  //     flex: 1,
                  //     child: MyButton(
                  //         label: 'كامرة',
                  //         onTab: () async {
                  //           if (titleController.text.isEmpty) {
                  //             await showAlertDialog(context);
                  //           } else {
                  //             if (book?.id != 0) {
                  //               // Save book first if it's new
                  //               await bookController.pickAndSaveImage(
                  //                   ImageSource.camera, book!);
                  //             } else {
                  //               await showAlertDialog(context,
                  //                   message: 'يرجى حفظ المعلومات اولا');
                  //             }
                  //
                  //             imageName.value = titleController.text;
                  //           }
                  //         },
                  //         width: SizeConfig.screenWidth,
                  //         widget: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Icon(
                  //             Icons.camera_alt_outlined,
                  //             color: Colors.white,
                  //           ),
                  //         )),
                  //   ),
                  //   Flexible(
                  //     child: MyButton(
                  //         label: 'الاستوديو',
                  //         onTab: () async {
                  //           if (titleController.text.isEmpty) {
                  //             await showAlertDialog(context);
                  //           } else {
                  //             if (book?.id != 0) {
                  //               // Save book first if it's new
                  //               await bookController.pickAndSaveImage(
                  //                   ImageSource.gallery, book!);
                  //             } else {
                  //               await showAlertDialog(context,
                  //                   message: 'يرجى حفظ المعلومات اولا');
                  //             }
                  //
                  //             imageName.value = titleController.text;
                  //
                  //             PaintingBinding.instance.imageCache.clear();
                  //           }
                  //         },
                  //         width: SizeConfig.screenWidth,
                  //         widget: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Icon(
                  //             Icons.image,
                  //             color: Colors.white,
                  //           ),
                  //         )),
                  //   ),
                  //   MyButton(
                  //       label: '',
                  //       onTab: () async {
                  //         PaintingBinding.instance.imageCache.clear();
                  //         setState(() {});
                  //       },
                  //       width: 50,
                  //       widget: Center(
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Icon(
                  //             Icons.refresh,
                  //             color: Colors.white,
                  //             size: 30,
                  //           ),
                  //         ),
                  //       ))
                  // ]),
                  // book!.imagePaths.isNotEmpty
                  //     ? GridView.builder(
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         gridDelegate:
                  //             SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 2, // Number of columns
                  //           crossAxisSpacing: 10.0,
                  //           mainAxisSpacing: 10.0,
                  //         ),
                  //         itemCount: book?.imagePaths.length,
                  //         itemBuilder: (context, index) {
                  //           String? imagePath = book?.imagePaths[index];
                  //           return BuildImageTile(
                  //             imagePath: imagePath ?? '',
                  //           );
                  //         },
                  //       )
                  //     : Center(
                  //         child: Text(
                  //           'لا توجد صور',
                  //           style: TextStyle(fontSize: 16, color: Colors.grey),
                  //         ),
                  //       ),

                  MyButton(
                    label: 'حفظ',
                    onTab: () async {
                      fullBookData(bookId);
                      try {
                        if (bookId == 0) {
                          int newBookId = await bookController.addBook(book!);
                          book!.id = newBookId;
                          // Redirect to image addition page
                          Get.toNamed('/AddImages',
                              arguments: {'bookId': newBookId});
                        } else {
                          await bookController.updateBook(book!);
                          Get.toNamed('/AddImages',
                              arguments: {'bookId': book?.id});
                        }
                        SnackBars().snackBarSuccess('تم الحفظ بنجاح', '');
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
            );
          }),
    );
  }

  void fullBookData(int? bookId) {
    book ??= Book();
    book!.id = bookId == 0 ? null : bookId;
    book!.title = titleController.text;
    book!.number = numberController.text;
    book!.date = dateController.text.isNotEmpty
        ? DateTime.parse(dateController.text)
        : null;
    book!.mutawalliMargin = mutawalliMarginController.text;
    book!.aminMargin = aminMarginController.text;
    book!.followup = followupController.text;
    book!.procedure = procedureController.text;
    book!.notes = notesController.text;
    book!.pdfPath = ''; // Set the PDF path if available
  }
}
