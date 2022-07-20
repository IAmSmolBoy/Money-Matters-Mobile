import 'package:flutter/material.dart';
import 'package:moneymattersmobile/screenData.dart';

class ScreenHeader extends StatelessWidget {
  String screenTitle;
  Widget childWidget;
  ScreenHeader(this.screenTitle, this.childWidget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(screenTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColor,)),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 231,
            color: const Color(0xFF212529),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: childWidget,
            )
          )
        ]
      ),
    );
  }
}
