import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../Services/Styles/TextStyles.dart';


class MyLiquidLinearProgressIndicator extends StatelessWidget {
  const MyLiquidLinearProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: CircularPercentIndicator(
          radius: 120.0,
          lineWidth: 13.0,
          animation: true,
          percent: 0.0,
          center: const Text(
            "100.0%",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          footer: Text(
            "الرجاء الانتظار...",
            style: subHeadingStyle,
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.amber,
        ),
      ),
    );
    ;
  }
}
