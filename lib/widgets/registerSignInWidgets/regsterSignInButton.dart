import 'package:flutter/material.dart';
import 'package:moneymattersmobile/screenData.dart';

class RegisterSignInButton extends StatelessWidget {
  final String btnName;
  final void Function() onTap;
  final Color bgColour,
  textColor;
  const RegisterSignInButton(this.btnName, this.onTap, this.bgColour, this.textColor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        primary: bgColour,
        maximumSize: const Size(double.infinity, 60),
        minimumSize: const Size(double.infinity, 60),
      ),
      onPressed: onTap,
      child: Text(btnName, style: buttonText.copyWith(color: textColor),),
    );
  }
}
