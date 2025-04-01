import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Services/Colors/HexStringToColor.dart';
import '../../../Services/Styles/TextStyles.dart';
import '../../../Services/Themes/ThemeServices.dart';
import '../../../Services/Themes/Themes.dart';
import '../BooksList/BooksList.dart';
import '../Details/Details.dart';
import '../InsertBook/InsertBookScreen.dart';
import '../InsertBook/add_images_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      getPages: [
        GetPage(name: '/${InsertBook.routeName}', page: () => InsertBook()),
        GetPage(name: '/${BooksList.routeName}', page: () => BooksList()), // Use routeName here
        GetPage(
            name: '/${DetailsPage.routeName}', page: () => const DetailsPage()),
        GetPage(name: '/AddImages', page: () => const AddImagesPage()),
      ],
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         // ThemeServices().switchTheme();
          //       },
          //       icon: const Icon(
          //         Icons.person,
          //         size: 35,
          //         color: Colors.white,
          //       ))
          // ],
          backgroundColor: hexStringToColor('002F2F'),
          title: Text(
            'قسم المواقع الخارجية',
            style: appBarHeadingStyle.copyWith(fontSize: 15),
          ),
        ),
        body:  BooksList(),
      ),
    );
  }
}
