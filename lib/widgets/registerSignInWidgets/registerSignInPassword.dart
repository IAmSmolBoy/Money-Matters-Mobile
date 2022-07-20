import 'package:flutter/material.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/registerSignInTextField.dart';

class RegisterSignInPassword extends StatelessWidget {
  final bool passwordObscurity;
  final void Function() onTap;
  final void Function(String?) onSavedFunc;
  final String? Function(String?) validatorFunc;

  RegisterSignInPassword(this.passwordObscurity, this.onTap, this.onSavedFunc, this.validatorFunc, {Key? key}) : super(key: key);

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
        obscureText: passwordObscurity,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: onTap,
              icon: Icon(
                passwordObscurity ? Icons.visibility :
                Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
          ),
          contentPadding: EdgeInsets.all(20),
          hintText: "Password",
          hintStyle: bodyText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(18),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
