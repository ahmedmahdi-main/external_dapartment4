import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../Data/InitDatabase.dart';
import '../Models/Book.dart';
import '../Services/Config/GetStoragePermission.dart';

class BookController extends GetxController {
  final bookList = <Book>[].obs;
  Rx<bool> isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();
  Rx<String> path = ''.obs;

  @override
  onInit() async {
    super.onInit();
    isLoading.value = true;
    update();
    // await InitDatabase.initDatabase();
    await getAllBooks();
    isLoading.value = false;
    update();
  }

  Future<String> getPathFromHive() async {
    try {
      var box = await WindowsStorage.openHiveBox('myBox');
      String? path = box.get('storagePath'); // Retrieve the path
      return path ?? ''; // Return the path
    } catch (e) {
      debugPrint('Error retrieving path from Hive: $e'); // Log any errors
      return ''; // Return empty string if there's an error
    }
  }

  // Fetch all books from the database
  Future<void> getAllBooks() async {
    try {
      isLoading.value = true; // Set loading to true
      List<Book> books = await InitDatabase.getAllBooks(); // Fetch books from database
      bookList.assignAll(books); // Update the book list
      debugPrint('Books loaded: ${books.length}');
    } catch (e) {
      debugPrint('Error loading books: $e');
    } finally {
      isLoading.value = false; // Set loading to false
    }
  }

  // Insert a new book
  Future<int> addBook(Book book) async {
    if (InitDatabase.database == null) {
      await InitDatabase.initDatabase(); // Ensure database is initialized
    }
    var newId = await InitDatabase.insertBook(book);
    await getAllBooks(); // Refresh the book list
    return newId;
  }

  // Update a book
  Future<void> updateBook(Book book) async {
    isLoading.value = true;
    await InitDatabase.updateBook(book);
    await getAllBooks(); // Refresh the book list
    isLoading.value = false;
  }

  // Delete a book
  Future<void> deleteBook(Book book) async {
    isLoading.value = true;
    await InitDatabase.deleteBook(book);
    await getAllBooks();
    isLoading.value = false;
  }

  // Future<void> pickAndSavePdf(Book book) async {
  //   try {
  //     // Pick a PDF file using the file_picker package
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf'],
  //     );
  //
  //     if (result != null) {
  //       // Get the file path of the selected PDF
  //       String pdfPath = result.files.single.path!;
  //
  //       // Define the directory path where the PDF should be saved (same as images)
  //       String directoryPath = '/storage/emulated/0/External-Locations';
  //       Directory directory = Directory(directoryPath);
  //
  //       // Check if directory exists, create it if it doesn't
  //       if (!directory.existsSync()) {
  //         directory.createSync(recursive: true);
  //       }
  //
  //       // Define the file path for saving the PDF file
  //       String pdfSavePath = p.join(directory.path, '${book.title}.pdf');
  //
  //       // Save the PDF file to the directory
  //       File pdfFile = File(pdfPath);
  //       await pdfFile.copy(pdfSavePath);
  //
  //       // Update the book with the new PDF path
  //       book.pdfPath = pdfSavePath;
  //
  //       // Call your update method to store the changes
  //       await updateBook(book);
  //
  //       debugPrint('PDF file saved successfully: $pdfSavePath');
  //     } else {
  //       debugPrint('No PDF selected');
  //     }
  //   } catch (e) {
  //     debugPrint('Error picking or saving PDF: $e');
  //   }
  // }

  // Pick an image and add to the book's images
  Future<void> pickAndSavePdf(Book book) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        dialogTitle: 'Select PDF File',
      );

      if (result != null) {
        // Get Windows Documents folder path
        final documentsPath = _getWindowsDocumentsPath();

        // Create application-specific directory
        final appDir = Directory(
          p.join(documentsPath, 'MuseumLibrary', 'Books'),
        );
        if (!await appDir.exists()) {
          await appDir.create(recursive: true);
        }

        // Get source file and destination path
        final sourceFile = File(result.files.single.path!);
        final destPath = p.join(
          appDir.path,
          '${_sanitizeFileName(book.title ?? '')}.pdf',
        );

        // Copy file and update book
        await sourceFile.copy(destPath);
        book.pdfPath = destPath;
        await updateBook(book);

        debugPrint('PDF saved to: $destPath');
      }
    } catch (e) {
      debugPrint('Error handling PDF: ${e.toString()}');
    }
  }

  Future<void> pickAndSaveImage(ImageSource source, Book book) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        // Get Windows Documents folder path
        final documentsPath = _getWindowsDocumentsPath();

        // Create application-specific image directory
        final imageDir = Directory(
          p.join(
            documentsPath,
            'MuseumLibrary',
            'BookImages',
            _sanitizeFileName(book.title ?? ''),
          ),
        );

        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }

        // Generate safe filename
        final fileName =
            '${_sanitizeFileName(book.title ?? '')}_'
            '${DateTime.now().millisecondsSinceEpoch}.png';

        // Create destination path
        final imagePath = p.join(imageDir.path, fileName);

        // Copy image and update book
        await File(image.path).copy(imagePath);
        book.imagePaths.add(imagePath);
        await updateBook(book);

        debugPrint('Image saved to: $imagePath');
      }
    } catch (e) {
      debugPrint('Error handling image: ${e.toString()}');
    }
  }

  String _getWindowsDocumentsPath() {
    final userProfile = Platform.environment['USERPROFILE'];
    if (userProfile == null) {
      throw Exception('USERPROFILE environment variable not found');
    }
    return p.join(userProfile, 'Documents');
  }

  String _sanitizeFileName(String name) {
    // Remove invalid Windows filename characters
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '');
  }

  // Get books by title or author
  Future<void> getBooksByTitleOrAuthor(String input) async {
    isLoading.value = true;
    var books = await InitDatabase.searchBooksByTitleOrAuthor(input);
    bookList.assignAll(books);
    isLoading.value = false;
  }
}
