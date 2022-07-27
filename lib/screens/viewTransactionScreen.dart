import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneymattersmobile/models/transaction.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/widgets/screenFormat.dart';
import 'package:moneymattersmobile/widgets/screenHeader.dart';

class ViewTransactionScreen extends StatelessWidget {
  Transaction transaction;
  ViewTransactionScreen(this.transaction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<String> transactionInfo = [
      "Date: ${DateFormat("dd/MM/yyyy").format(transaction.date)}",
      "Category: ${transaction.category}",
      "Description: ${transaction.description}",
      "Amount: ${transaction.amount}",
    ];

    return ScreenFormat(
      ScreenHeader(
        "View Transaction",
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (c, j) =>
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: AutoSizeText(transactionInfo[j],
                minFontSize: 25,
                // style: TextStyle(color: textColor),
              ),
            ),
          itemCount: transactionInfo.length
        )
      ),
      logo: false,
    );
  }
}
