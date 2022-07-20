import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  List<String> transactionList;
  Function removeItem;
  TransactionList(this.transactionList, this.removeItem,  {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) => Container(),
        separatorBuilder: (context, i) => const Divider(thickness: 1, color: Colors.black),
        itemCount: transactionList.length
    );
  }
}
