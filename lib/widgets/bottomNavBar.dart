import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:moneymattersmobile/models/pageInfo.dart';
import 'package:moneymattersmobile/screenData.dart';

class BottomNavBar extends StatefulWidget {

  TabController pc;
  BottomNavBar(this.pc);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  //for navbar
  List<Map<String, dynamic>> pageData = [
    {
      "title": "Reports",
      "icon": Icons.assessment
    },
    {
      "title": "Home",
      "icon": Icons.home
    },
    {
      "title": "Add Transaction",
      "icon": Icons.add
    },
  ];

  int fontSize = 30;
  void fontSizeChange(newFontSize) => setState(() { fontSize = newFontSize; });

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      items: pageData.map<TabItem>((e) => TabItem( icon: e["icon"], title: e["title"] )).toList(),
      controller: widget.pc,
      activeColor: textColor,
      color: textColor,
      backgroundColor: const Color(0xFF212529),
    );
  }
}