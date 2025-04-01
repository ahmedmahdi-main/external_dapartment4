import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Services/Colors/GetColorsByMode.dart';
import '../../Services/Colors/HexStringToColor.dart';
import '../../Services/Themes/ThemeServices.dart';


SliverAppBar createImageSilverAppBar(String background, double height) {
  return SliverAppBar(
    backgroundColor: Colors.transparent,
    expandedHeight: height,
    floating: false,
    elevation: 10,
    flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                  color: Colors.white,
                  child: Image.asset(
                    'Assets/Images/$background.png',
                    fit: BoxFit.fill,
                  )));
        }),
  );
}

SliverAppBar createActionSilverAppBar() {
  return SliverAppBar(
      actions: [
        IconButton(
          onPressed: () async {
            ThemeServices().switchTheme();
          },
          icon: Get.isDarkMode
              ? const Icon(
            Icons.lightbulb,
            size: 25,
          )
              : const Icon(
            Icons.lightbulb_outline,
            size: 25,
          ),
          color: getColorByMode(),
        ),
      ],

      expandedHeight: 5,
      backgroundColor: hexStringToColor("2E419A"),
      pinned: true,
      title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 40,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 5.0),
            ],
          ),
          child: CupertinoTextField(
              keyboardType: TextInputType.text,
              placeholder: 'بحث',
              placeholderStyle: const TextStyle(
                color: Color(0xffC4C6CC),
                fontSize: 14.0,
                fontFamily: 'Brutal',
              ),
              prefix: const Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                  child: Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.black,
                  )),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ))));
}

SliverAppBar createSearchSilverAppBar() {
  return SliverAppBar(
      expandedHeight: 5,
      backgroundColor:  hexStringToColor("2E419A"),
      pinned: true,
      title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 40,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 5.0),
            ],
          ),
          child: CupertinoTextField(
              keyboardType: TextInputType.text,
              placeholder: 'بحث',
              placeholderStyle: const TextStyle(
                color: Color(0xffC4C6CC),
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
              ))));
}
