import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:moneymattersmobile/models/transaction.dart' as transModel;
import 'package:moneymattersmobile/screens/addTasnactionScreen.dart';
import 'package:moneymattersmobile/screens/viewTransactionScreen.dart';
import 'package:moneymattersmobile/widgets/homeListText.dart';
import 'package:page_transition/page_transition.dart';

class HomeListTile extends StatelessWidget {
  int i;
  BuildContext c;
  void Function (int i) deleteTransaction;
  int month;
  List<transModel.Transaction> transList;
  HomeListTile(this.i, this.c, this.deleteTransaction, this.month, this.transList, {Key? key}) : super(key: key);

  //function to find text size
  Size calculateTextSize(
      String text,
      TextStyle style,
      ) {
    final double textScaleFactor = MediaQuery.of(c).textScaleFactor;

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: ui.TextDirection.ltr,
      textScaleFactor: textScaleFactor,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size;
  }
  List<List<double>> listTextMaxWidths = [];

  @override
  Widget build(BuildContext context) {

    double listTextWidth = (MediaQuery.of(c).size.width - 64) / 4 - 10;

    //function to determine AutoSizeText size
    double determineSize(String content, double fontSize) =>
      min(calculateTextSize(content, TextStyle(fontSize: fontSize)).width, listTextWidth);

    //list of all the list tile widths
    for (transModel.Transaction transaction in transList) {
      listTextMaxWidths.add([
        determineSize(DateFormat("dd/MM/yyyy").format(transaction.date), 10),
        determineSize(transaction.category, 25),
        determineSize(transaction.amount.toString(), 17.5)
      ]);
    }

    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: ()  => deleteTransaction(i),
        ),
        children: [
          SlidableAction(
            onPressed: (BuildContext c) {
              Navigator.push(context, PageTransition(
                child: AddTransactionScreen(transaction: transList[i],),
                childCurrent: this,
                type: PageTransitionType.topToBottom,
                duration: const Duration(milliseconds: 200),
                reverseDuration: const Duration(milliseconds: 200),
              ));
            },
            backgroundColor: const Color(0xFF009fdd),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (BuildContext c) => deleteTransaction(i),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(context, PageTransition(
            child: ViewTransactionScreen(transList[i]),
            childCurrent: this,
            type: PageTransitionType.topToBottom,
            duration: const Duration(milliseconds: 200),
            reverseDuration: const Duration(milliseconds: 200),
          ));
        },
        contentPadding: EdgeInsets.zero,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                HomeListText(
                  DateFormat("dd/MM/yyyy").format(transList[i].date),
                  10,
                  listTextMaxWidths[i][0],
                ),
                const SizedBox(width: 5,),
                HomeListText(
                  transList[i].category,
                  25,
                  listTextMaxWidths[i][1],
                ),
                const SizedBox(width: 5,),
                HomeListText(
                  transList[i].description,
                  15,
                  MediaQuery.of(c).size.width - listTextMaxWidths[i].reduce((a, b) => a + b) - 74,
                ),
              ],
            ),
            HomeListText(
              transList[i].amount.toString(),
              17.5,
              listTextMaxWidths[i][2],
            ),
          ],
        )
      ),
    );
  }
}
