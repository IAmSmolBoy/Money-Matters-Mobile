import 'package:flutter/material.dart';
import 'package:moneymattersmobile/screenData.dart';

class EditProfileTextField extends StatefulWidget {
  String labelText;
  void Function(String?) onSavedFunc;
  bool password;
  String? Function(String?)? validator = (val) => null;
  TextEditingController? controller;

  EditProfileTextField({required this.labelText, required this.onSavedFunc, this.controller, this.password = false, this.validator, Key? key }) : super(key: key);

  @override
  State<EditProfileTextField> createState() => _EditProfileTextFieldState();
}

class _EditProfileTextFieldState extends State<EditProfileTextField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.password && !showPassword,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: textColor,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: textColor,
            ),
          ),
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          suffixIcon: widget.password ?
          IconButton(
            icon: Icon(
              showPassword ? Icons.remove_red_eye
              : Icons.remove_red_eye_outlined,
              color: Colors.grey,
            ),
            onPressed: () => setState(() => showPassword = !showPassword),
          ) :
          null
        ),
        onSaved: widget.onSavedFunc,
        validator: (String? val) => val != null && val.isEmpty ? "Please enter your " + widget.labelText : widget.validator != null ? widget.validator!(val) : null,
      ),
    );
  }
}