import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/services/auth.dart';
import 'package:moneymattersmobile/services/firestore.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/registerSignInTextField.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/regsterSignInButton.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({ Key? key }) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  GlobalKey<FormState> form = GlobalKey();
  List<User> userList = [];
  String email = "";

  @override
  void initState() {
    readUsers().then((users) {
      setState(() {
        userList = users;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 25.0),
            children: <TextSpan>[
              const TextSpan(text: 'Money', style: TextStyle(color: Colors.green)),
              TextSpan(text: 'Matters', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
      ),
      body: userList.isEmpty ?
      const Center(child: CircularProgressIndicator()) :
      GestureDetector(
        onTap: () { FocusScope.of(context).unfocus(); },
        child: SafeArea(
            child: CustomScrollView(
              reverse: true,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Welcome back.", style: headlines,),
                              const SizedBox(height: 10,),
                              Text("You've been missed!", style: bodyText2,),
                              const SizedBox(height: 60,),
                              Form(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                key: form,
                                child: Column(
                                  children: [
                                    RegisterSignInTextField(
                                    TextInputType.emailAddress,
                                    "Email",
                                    (val) { email = val!; },
                                    (val) => val == null || val == "" ? "Enter an email" :
                                    !EmailValidator.validate(val) ? "Enter a valid email" :
                                    null,
                                  ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        RegisterSignInButton(
                          "Reset Password",
                          () async {
                            if (form.currentState!.validate()) {
                              form.currentState!.save();
                              resetPass(email).then((res) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                      res,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  )
                                );
                              });
                            }
                          },
                          Colors.white,
                          Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ),
    );
  }
}