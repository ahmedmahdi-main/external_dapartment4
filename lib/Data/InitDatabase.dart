
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../Models/Book.dart';

class InitDatabase {
  static Database? database;
  static const int _version = 1;
  static const String _tableNameBooks = 'Books';
  static const String _tableNameBookImages = 'BookImages';

  static const String createBooksTable = '''
    CREATE TABLE Books(
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      number TEXT,
      date TEXT,
      aminMargin TEXT,
      mutawalliMargin TEXT,
      followup TEXT,
      procedure TEXT,
      notes TEXT,
      pdfPath TEXT
    );
  ''';

  static const String createBookImagesTable = '''
    CREATE TABLE BookImages(
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      bookId INTEGER NOT NULL,
      imagePath TEXT,
      FOREIGN KEY (bookId) REFERENCES Books(id) ON DELETE CASCADE
    );
  ''';

  static Future<void> initDatabase() async {
    if (database != null) {
      debugPrint('Database is already initialized.');
      return;
    }
    try {
      final databasesPath = await getDatabasesPath();
      final dbPath = path.join(databasesPath, 'external_locations.db');

      database = await openDatabase(
        dbPath,
        version: _version,
        onCreate: (Database db, int version) async {
          await db.execute('PRAGMA foreign_keys = ON;');
          await db.execute(createBooksTable);
          await db.execute(createBookImagesTable);
          debugPrint('Database and tables created successfully.');
        },
      );
    } catch (ex) {
      debugPrint('Database initialization error: ${ex.toString()}');
    }
  }

  // Insert a book and its images
  static Future<int> insertBook(Book book) async {
    if (database == null) {
      throw Exception('Database is not initialized. Call InitDatabase.initDatabase() first.');
    }

    // Validate that required fields are not null or empty
    if (book.title != null) {
      if (book.title!.isEmpty) {
        debugPrint('Book data is incomplete, cannot insert.');
        return -1; // or any other way to handle incomplete data
      }
    }

    int bookId = await database!.insert(_tableNameBooks, book.toJson());

    // Check if bookId is valid
    if (bookId == -1) {
      debugPrint('Book insertion failed.');
      return bookId;
    }

    // Inserting images related to the book
    Batch batch = database!.batch();
    for (String imagePath in book.imagePaths) {
      batch.insert(_tableNameBookImages, {
        'bookId': bookId,
        'imagePath': imagePath,
      });
    }
    await batch.commit();

    return bookId;
  }

  // Update a book and its images
  static Future<void> updateBook(Book book) async {
    await database!.update(_tableNameBooks, book.toJson(),
        where: 'id = ?', whereArgs: [book.id]);

    // Get current images for the book
    List<Map<String, dynamic>> currentImages = await database!.query(
      _tableNameBookImages,
      where: 'bookId = ?',
      whereArgs: [book.id],
    );

    // Extract current image paths
    List<String> currentImagePaths =
        currentImages.map((imgMap) => imgMap['imagePath'] as String).toList();

    // Find new images to add
    List<String> newImages = book.imagePaths
        .where((imgPath) => !currentImagePaths.contains(imgPath))
        .toList();

    // Find images to delete
    List<String> imagesToDelete = currentImagePaths
        .where((imgPath) => !book.imagePaths.contains(imgPath))
        .toList();

    // Insert new images
    Batch batchInsert = database!.batch();
    for (String imagePath in newImages) {
      batchInsert.insert(_tableNameBookImages, {
        'bookId': book.id,
        'imagePath': imagePath,
      });
    }
    await batchInsert.commit();

    // Delete images that are not needed
    Batch batchDelete = database!.batch();
    for (String imagePath in imagesToDelete) {
      batchDelete.delete(
        _tableNameBookImages,
        where: 'bookId = ? AND imagePath = ?',
        whereArgs: [book.id, imagePath],
      );
    }
    await batchDelete.commit();
  }

  // Get all books with their images
  static Future<List<Book>> getAllBooks() async {
    final List<Map<String, dynamic>> bookMaps =
        await database!.query(_tableNameBooks);
    List<Book> books = [];

    for (var bookMap in bookMaps) {
      int bookId = bookMap['id'];
      List<Map<String, dynamic>> imageMaps = await database!.query(
        _tableNameBookImages,
        where: 'bookId = ?',
        whereArgs: [bookId],
      );

      List<String> imagePaths =
          imageMaps.map((imgMap) => imgMap['imagePath'] as String).toList();
      Book book = Book.fromJson(bookMap);
      book.imagePaths = imagePaths;
      books.add(book);
    }

    return books;
  }

  // Delete a book and its images
  static Future<int> deleteBook(Book book) async {
    // Explicitly delete images
    await database!.delete(
      _tableNameBookImages,
      where: 'bookId = ?',
      whereArgs: [book.id],
    );

    // Delete the book
    return await database!
        .delete(_tableNameBooks, where: 'id = ?', whereArgs: [book.id]);
  }

  // Search for books by title
  static Future<List<Book>> searchBooksByTitleOrAuthor(String input) async {
    String query =
        "SELECT * FROM $_tableNameBooks WHERE title LIKE '%$input%';";
    final List<Map<String, dynamic>> bookMaps =
        await database!.rawQuery(query);

    List<Book> books = [];
    for (var bookMap in bookMaps) {
      int bookId = bookMap['id'];
      List<Map<String, dynamic>> imageMaps = await database!.query(
        _tableNameBookImages,
        where: 'bookId = ?',
        whereArgs: [bookId],
      );

      List<String> imagePaths =
          imageMaps.map((imgMap) => imgMap['imagePath'] as String).toList();
      Book book = Book.fromJson(bookMap);
      book.imagePaths = imagePaths;
      books.add(book);
    }

    return books;
  }
}
