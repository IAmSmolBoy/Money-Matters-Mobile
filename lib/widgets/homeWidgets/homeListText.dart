import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:moneymattersmobile/screenData.dart';

class HomeListText extends StatelessWidget {
  double fontSize, width;
  String content;
  HomeListText(this.content, this.fontSize, this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AutoSizeText(
        content,
        stepGranularity: 0.5,
        maxFontSize: fontSize,
        minFontSize: fontSize,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).primaryColor,),
      ),
    );
  }
}
