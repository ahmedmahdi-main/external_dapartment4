import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Services/Colors/Colors.dart';
import '../../Services/Styles/TextStyles.dart';

class NoBooksMsg extends StatelessWidget {
  const NoBooksMsg({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
          child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
            SvgPicture.asset(
              'Assets/Images/NoBooks.svg',
              height: 290,
              semanticsLabel: 'لا يوجد معلومات',
              color: primaryClr.withOpacity(0.3),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  'لا يوجد كتب لحد الان ',
                  style: subHeadingStyle,
                  textAlign: TextAlign.center,
                ))
          ]))
    ]);
  }
}
