import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/shape/gf_avatar_shape.dart';
import 'package:intl/intl.dart';

import '../../Models/Book.dart';
import '../../Services/Colors/Colors.dart';
import '../../Services/Colors/HexStringToColor.dart';
import '../../Services/Styles/TextStyles.dart';
import '../Screens/Details/Details.dart';
import '../../Widgets/StyledText.dart'; // Import the new StyledText widget

class MyGFListTile extends StatelessWidget {
  final Book book;

  const MyGFListTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(),
          color: primaryClr.withOpacity(0.9),
          borderRadius: BorderRadius.circular(5),
        ),
        child: GFListTile(
          color: Colors.white.withOpacity(0.9),
          
          margin: const EdgeInsets.all(10),
          onTap: () {
            if (book.id != null) {
              sendData(book.id); // Navigate to the details page
            } else {
              Get.snackbar(
                'خطأ',
                'لا يمكن عرض التفاصيل لأن معرف الكتاب غير متوفر',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          title: book.title != null
              ? Text(
                  book.title!,
                  style:
                      headingStyle.copyWith(color: Colors.white, fontSize: 15),
                )
              : notFind(),
          subTitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  book.number != null
                      ? StyledText(text: 'العدد: ${book.number!}')
                      : notFind(),
                  StyledText(
                    text: 'التاريخ : ${book.date != null ? DateFormat('dd-MM-yyyy').format(book.date!.toLocal()) : 'غير متوفر'}',
                  ),
                  book.aminMargin != null
                      ? StyledText(text: 'هامش الامين: ${book.aminMargin!}')
                      : notFind(),
                  book.mutawalliMargin != null
                      ? StyledText(text: 'هامش المتولي: ${book.mutawalliMargin!}')
                      : notFind(),
                  book.followup != null
                      ? StyledText(text: 'المتابعة: ${book.followup!}')
                      : notFind(),
                  book.procedure != null
                      ? StyledText(text: 'الاجارء: ${book.procedure!}')
                      : notFind(),
                  book.notes != null
                      ? StyledText(text: 'ملاحظات: ${book.notes!}')
                      : notFind(),
                ],
              ),
            ],
          ),
          padding: const EdgeInsets.all(5),
          avatar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 15.0,
                ),
              ],
            ),
            child: GFAvatar(
              radius: 45,
              shape: GFAvatarShape.standard,
              borderRadius: BorderRadius.circular(55),
              backgroundImage: const AssetImage('Assets/Images/foreground.png'),
              backgroundColor: hexStringToColor('#006A71'),
              child: book.id != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        book.id.toString(),
                        style: subHeadingStyle.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                    )
                  : notFind(),
            ),
          ),
        ),
      ),
    );
  }

  void sendData(int? bookId) {
    Get.toNamed('/${DetailsPage.routeName}', arguments: {
      'bookId': bookId,
    });
  }

  Text notFind() => Text(
        'لا يوجد',
        style: subHeadingStyle.copyWith(color: Colors.red),
      );
}
