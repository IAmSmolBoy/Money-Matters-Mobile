import 'package:flutter/material.dart';
import 'package:moneymattersmobile/screenData.dart';

class RegisterSignInTextField extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final void Function(String?) onSavedFunc;
  final String? Function(String?) validatorFunc;

  RegisterSignInTextField(this.inputType, this.hintText, this.onSavedFunc, this.validatorFunc, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        style: bodyText.copyWith(
          color: Colors.white,
        ),
        onSaved: onSavedFunc,
        validator: validatorFunc,
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          hintText: hintText,
          hintStyle: bodyText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}