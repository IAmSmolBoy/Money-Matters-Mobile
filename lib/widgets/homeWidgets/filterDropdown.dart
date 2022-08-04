import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {

  String title;
  List<String> itemList;
  int? initialValue;
  void Function(int)? changeVal;
  FilterDropdown(this.title, this.itemList, [this.changeVal, this.initialValue]);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: initialValue != null ? itemList[initialValue!] : null,
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        label: Text(title,
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 20,
        color: Theme.of(context).primaryColor,
      ),
      items: itemList.map((e) => DropdownMenuItem<String>(child: Text(e), value: e)).toList(),
      onChanged: (e) { if (changeVal != null) changeVal!(itemList.indexOf(e!)); }
    );
  }

}