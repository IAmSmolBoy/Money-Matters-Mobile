import 'package:flutter/material.dart';
import 'package:moneymattersmobile/widgets/homeSecTitle.dart';

class SortBySection extends StatelessWidget {

  List<String> sortByList = ["Date", "Amount (Descending)", "Amount (Ascending)"];
  List<Widget> sortColWidgetList = [HomeSectionTitle("Sort By")];
  Function changeSortBy;
  String currSortBy;
  SortBySection(this.changeSortBy, this.currSortBy);

  @override
  Widget build(BuildContext context) {


    //adding into the column widget list
    for (var sortEle in sortByList) {
      sortColWidgetList.addAll([
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            changeSortBy(sortEle);
          },
          child: sortEle == currSortBy ? Text(sortEle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF8F9FA),
            )
          ) :
          Text(sortEle,
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFFF8F9FA),
            )
          )
        ),
      ]);
    }


    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sortColWidgetList,
      );
  }

}