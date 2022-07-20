import 'package:flutter/material.dart';
import 'package:moneymattersmobile/screenData.dart';

class AddTransactionDropdown extends StatelessWidget {
  String label;
  List<DropdownMenuItem<String>> dropdownList;
  void Function(String?)? onChangedFunc;
  void Function(String?) onSavedFunc;
  GlobalKey<FormFieldState>? dropdownKey;
  String? initialVal;

  String? validateInput(val, String missingVal, [bool additionalValidation = false, String? errMsg]) =>
      val == null || val.isEmpty ? "Please enter the transaction $missingVal" : additionalValidation ? errMsg : null;

  AddTransactionDropdown(this.label, this.dropdownList, this.onSavedFunc,  {this.onChangedFunc, this.dropdownKey, this.initialVal, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: dropdownKey,
      value: initialVal,
      dropdownColor: const Color(0xFF212529),
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textColor)
          ),
          labelStyle: TextStyle(color: textColor,),
          labelText: label
      ),
      style: TextStyle(fontSize: 20, color: textColor,),
      items: dropdownList,
      onChanged: onChangedFunc ?? (val) {},
      validator: (val) => validateInput(val, label),
      onSaved: onSavedFunc,
    );
  }
}
