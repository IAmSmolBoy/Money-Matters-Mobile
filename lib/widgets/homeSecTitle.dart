import 'package:flutter/material.dart';

class HomeSectionTitle extends StatelessWidget {
  String title;
  HomeSectionTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFF8F9FA)),
    );
  }
}
