import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';le/flutter_slidable.dart';
import 'package:flutter/foundation.dart'; // For platform checks
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Import the PDF viewer package
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Import the PDF viewer package
import '../../../Controllers/BookController.dart';
import '../../../Models/Book.dart';ntroller.dart';
import '../../../Services/Colors/Colors.dart';
import '../../../Services/Colors/HexStringToColor.dart';
import '../../../Services/SnackBars/Snackbars.dart';rt';
import '../../Widgets/MyGFListTile.dart';bars.dart';
import '../../Widgets/MyLiquidLinearProgressIndicator.dart';
import '../../Widgets/MySliverAppBar.dart';sIndicator.dart';
import '../../Widgets/NoBooksWidget.dart';;
import '../AlertDialogs/AlertDialog.dart';
import '../InsertBook/InsertBookScreen.dart';
import '../../../Widgets/StyledText.dart'; // Import the new StyledText widget
import '../../../Widgets/StyledText.dart'; // Import the new StyledText widget
class BooksList extends StatefulWidget {
  const BooksList({super.key});
  const BooksList({super.key});
  static const String routeName = 'BooksList';
  static const String routeName = 'BooksList';
  @override
  State<BooksList> createState() => _BooksListState();
}reateState() => _BooksListState();

class _BooksListState extends State<BooksList> {
  final BookController controllers = BookController();te extends State<BooksList> {
  final TextEditingController _editingController = TextEditingController();er controllers = Get.put(BookController());
  final ScrollController _scrollController = ScrollController(); _editingController = TextEditingController();
  List<Book> books = [];);
  Book? selectedBook;
= 0.obs;
  @overrideselectedBook = Rx<Book?>(null); // Track the selected book
  void initState() {
    super.initState();
    _fetchBooks(); // Fetch books initially
  }itState();
Books(); // Fetch books initially
  void _fetchBooks() async {
    setState(() {
      controllers.isLoading = true;
    });ddPostFrameCallback((_) async {
    try {
      await controllers.getAllBooks();
      setState(() {ait controllers.getAllBooks(); // Fetch books
        books = controllers.bookList;s.bookList.stream); // Bind the book list to the controller stream
      });fetched successfully: ${books.length}');
    } catch (e) {
      debugPrint('Error fetching books: $e');'Error fetching books: $e');
    } finally {
      setState(() {ntrollers.isLoading.value = false; // Set loading to false
        controllers.isLoading = false;
      });;
    }
  }

  @overridedContext context) {
  Widget build(BuildContext context) {
    return Scaffold(
      body: kIsWeb || defaultTargetPlatform == TargetPlatform.windows
          ? Row(              children: [
              children: [nded(
                Expanded(lex: 2,
                  flex: 2,
                  child: Container(     color: hexStringToColor('006A71').withAlpha(10),
                    color: hexStringToColor('006A71').withAlpha(10), _buildSidebar(),
                    child: _buildSidebar(),
                  ),    ),
                ),
                Expanded(lex: 5,
                  flex: 5,ontent(),
                  child: _buildMainContent(),
                ),
              ],
            )
          : _buildMobileLayout(),loatingActionButton(
      floatingActionButton: FloatingActionButton(ryClr,
        backgroundColor: primaryClr,) async {
        onPressed: () async {tBook page and refresh the book list when returning
          await Navigator.pushNamed(context, '/InsertBook', arguments: {'bookId': 0});ertBook', arguments: {'bookId': 0});
          _fetchBooks(); // Refresh the book list
        },
        tooltip: 'اضافة كتاب جديد',
        child: const Icon(con(
          Icons.add,
          size: 45,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSidebar() {ildSidebar() {
    return Column(ng searchQuery = ''.obs; // Observable for the search query
      children: [
        const SizedBox(height: 20),urn Obx(() {
        Text(   // Filter books based on the search query
          'قائمة الكتب',      var filteredBooks = books.where((book) {
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryClr),LowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
        ),k.number?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);
        const Divider(),
        Expanded(
          child: ListView.separated(
            itemCount: books.length, children: [
            itemBuilder: (context, index) {dBox(height: 20),
              var book = books[index];
              return GestureDetector(ignment.center,
                onTap: () {
                  setState(() {    Text(
                    selectedBook = book;        'قائمة الكتب',
                  });         style: TextStyle(fontSize: 24.5, fontWeight: FontWeight.bold, color: primaryClr),
                },           ),
                child: Card(             const SizedBox(width: 10),
                  elevation: 4,              Container(








































































              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(            child: GridView.builder(          Expanded(          const SizedBox(height: 10),            StyledText(text: 'الصور:'),          if (book.imagePaths.isNotEmpty)          const SizedBox(height: 10),            ),              ),                ),                  title: StyledText(text: 'عرض ملف PDF'),                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),                child: ListTile(                elevation: 4,              child: Card(              },                Navigator.pushNamed(context, '/PdfViewer', arguments: {'pdfPath': book.pdfPath});                debugPrint('Opening PDF: ${book.pdfPath}');              onTap: () {            GestureDetector(          if (book.pdfPath != null && book.pdfPath!.isNotEmpty)          const SizedBox(height: 10),          StyledText(text: 'العنوان: ${book.title ?? 'لا يوجد عنوان'}'),        children: [        crossAxisAlignment: CrossAxisAlignment.start,      child: Column(      height: double.infinity,      width: double.infinity,      padding: const EdgeInsets.all(16.0),    return Container(    var book = selectedBook!;    }      );        child: StyledText(text: 'يرجى اختيار كتاب من القائمة لعرض الملفات.'),      return Center(    if (selectedBook == null) {  Widget _buildMainContent() {  }    );      ],        ),          ),            },              return const Divider();            separatorBuilder: (BuildContext context, int index) {            },              );                ),                  ),                    ),                      ],                        StyledText(text: 'رقم: ${book.number ?? 'لا يوجد رقم'}'),                        const SizedBox(height: 10),                        ),                          ],                            StyledText(text: 'العنوان: ${book.title ?? 'لا يوجد عنوان'}'),                            const SizedBox(width: 10),                            const Icon(Icons.book, color: Colors.blue),                          children: [                        Row(                      children: [                      crossAxisAlignment: CrossAxisAlignment.start,                    child: Column(                    padding: const EdgeInsets.all(10),                  child: Padding(                  color: Colors.white,                  ),                    borderRadius: BorderRadius.circular(15),                  shape: RoundedRectangleBorder(                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryClr,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${books.length}', // Display the count of books
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
                    selectedBook.value = book; // Update the selected book
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
                                      _editItem(book); // Navigate to the edit screen
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await _confirmAndDeleteBook(book); // Confirm and delete the book
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

  Future<void> _confirmAndDeleteBook(Book book) async {
    var result = await AlertDialogs.yesNoDialog(
        context, 'حذف الكتاب', 'هل تريد تأكيد حذف الكتاب "${book.title}"؟');
    if (result == DialogsAction.yes) {
      try {
        await controllers.deleteBook(book); // Call the delete method from the controller
        SnackBars().snackBarSuccess('تم حذف الكتاب بنجاح', '');
      } catch (e) {
        SnackBars().snackBarFail('حدث خطأ أثناء حذف الكتاب', e.toString());
      }
    }
  }

  Widget _buildMainContent() {
    return Obx(() {
      if (selectedBook.value == null) {
        return Center(
          child: StyledText(text: 'يرجى اختيار كتاب من القائمة لعرض الملفات.'),
        );
      }

      var book = selectedBook.value!;
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
                            // Handle PDF viewing logic here
                            debugPrint('Opening PDF: ${book.pdfPath}');
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
                            // Handle image viewing logic here
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

  Widget _buildMobileLayout() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
        return <Widget>[
          createImageSilverAppBar('background', 190),
          createSilverAppBar2(),
        ];
      },
      body: Obx(() {
        if (controllers.isLoading.value) {
          return const MyLiquidLinearProgressIndicator();
        }
        count.value = books.length;
        if (books.isEmpty) {
          return const NoBooksMsg();
        }
        return ListView.builder(
          controller: _scrollController,
          itemCount: books.length,
          itemBuilder: (BuildContext context, int index) {
            var book = books[index];
            return Slidable(
              startActionPane:
                  ActionPane(motion: const ScrollMotion(), children: [
                SlidableAction(
                  onPressed: ((context) async {
                    await _deleteItem(book);
                  }),
                  backgroundColor: hexStringToColor('A31118'),
                  icon: Icons.delete,
                  label: 'حذف',
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  padding: const EdgeInsets.all(15),
                  spacing: 15,
                )
              ]),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: ((context) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _editItem(book);
                      });
                    }),
                    backgroundColor: darkGreyClr,
                    icon: Icons.edit,
                    label: 'تعديل',
                    autoClose: true,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(15)),
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
        backgroundColor: hexStringToColor('006A71').withOpacity(0.5),
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
                        await controllers.getBooksByTitleOrAuthor(input);
                      },
                      controller: _editingController,
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
                      )),
                ),
              ],
            )));
  }

  void _editItem(Book book) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.toNamed(InsertBook.routeName, arguments: {
        'bookId': book.id,
      });
    });
  }

  Future<void> _deleteItem(Book book) async {
    var result = await AlertDialogs.yesNoDialog(
        context, 'حذف معلومات', 'هل تريد تأكيد على حذف ؟');
    if (result == DialogsAction.yes) {
      controllers.deleteBook(book);
      SnackBars().snackBarSuccess('تم الحذف بنجاح', '');
    }
  }
}
