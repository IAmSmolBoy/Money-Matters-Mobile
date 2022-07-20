import 'package:flutter/material.dart';
import 'package:moneymattersmobile/screenData.dart';

class AddTransactionFormField extends StatelessWidget {

  String label;
  TextInputType keyboardType;
  Function (String?) onSaveFunc;
  String? Function (String?) validatorFunc;
  EdgeInsets? decPadding;
  void Function()? chooseDateFunc;
  TextEditingController? textFieldController;
  String? initialVal;

  AddTransactionFormField(this.label, this.keyboardType, this.onSaveFunc, this.validatorFunc,
  {this.chooseDateFunc, this.textFieldController, this.initialVal, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (textFieldController != null) textFieldController!.text = initialVal!;

    return TextFormField(
      initialValue: textFieldController == null ? initialVal : null,
      style: TextStyle(color: textColor),
      controller: textFieldController,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: textFieldController != null ? const EdgeInsets.fromLTRB(15, 5, 0, 5) : null,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor)
        ),
        labelStyle: TextStyle(color: textColor,),
        labelText: label,
        suffix: chooseDateFunc != null ? TextButton(
          onPressed: chooseDateFunc,
          child: const Text("Pick a date"),
        ) : null,
      ),
      onSaved: onSaveFunc,
      validator: validatorFunc,
    );
  }
}
