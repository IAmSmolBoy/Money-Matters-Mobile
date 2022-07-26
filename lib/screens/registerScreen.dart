import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:moneymattersmobile/main.dart';
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/screens/signInScreen.dart';
import 'package:moneymattersmobile/services/auth.dart';
import 'package:moneymattersmobile/services/firestore.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/registerSignInPassword.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/registerSignInTextField.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/regsterSignInButton.dart';
import 'package:page_transition/page_transition.dart';

class RegisterScreen extends StatefulWidget {
  String? username, email, password;

  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> form = GlobalKey<FormState>();

  bool passwordObscurity = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff191720),
      appBar: AppBar(
        backgroundColor: const Color(0xff191720),
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 25.0, color: Color(0xFFF8F9FA)),
            children: <TextSpan>[
              TextSpan(text: 'Money', style: TextStyle(color: Colors.green)),
              TextSpan(text: 'Matters'),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<User>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          List<String> usernameList = [];
          if (snapshot.hasError) {
            Future.delayed(
              const Duration(microseconds: 0),
              () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${snapshot.error}"))
              )
            );
          }
          usernameList = snapshot.data?.map((user) => user.username).toList() ?? [];
          return snapshot.connectionState != ConnectionState.active ?
          const CircularProgressIndicator() :
          GestureDetector(
            onTap: () { FocusScope.of(context).unfocus(); },
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20
                      ),
                      child: Column(
                        children: [
                          Flexible(
                            child: Form(
                              key: form,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Register", style: headlines,),
                                  Text("Create new account to get started.", style: bodyText2,),
                                  const SizedBox(height: 50,),
                                  RegisterSignInTextField(
                                    TextInputType.text,
                                    "Username",
                                    (val) { widget.username = val!; },
                                    (val) =>
                                    val == null || val == "" ? "Enter a username" :
                                    val.length > 32 ? "Username cannot exceed 32 characters" :
                                    usernameList.contains(val) ? "This username has been taken" :
                                    null,
                                  ),
                                  RegisterSignInTextField(
                                    TextInputType.emailAddress,
                                    "Email",
                                    (val) { widget.email = val!; },
                                    (val) => val == null || val == "" ? "Enter an email" :
                                    !EmailValidator.validate(val) ? "Enter a valid email" :
                                    null,
                                  ),
                                  RegisterSignInPassword(
                                    passwordObscurity,
                                    () => setState(() { passwordObscurity = !passwordObscurity; }),
                                    (val) { widget.password = val!; },
                                    (val) => val == null || val == "" ? "Enter a password" :
                                    null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account? ", style: bodyText,),
                              TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      child: SignInScreen(),
                                      childCurrent: widget,
                                      type: PageTransitionType.rightToLeftJoined
                                    )
                                  );
                                },
                                child: Text("Sign In", style: bodyText.copyWith(color: Colors.white),),
                              ),
                            ],
                          ),
                          RegisterSignInButton(
                            "Register",
                            () async {
                              if (form.currentState!.validate()) {
                                form.currentState!.save();
                                String registerRes = await register(widget.username!, widget.email!, widget.password!);
                                if (registerRes == "Success") {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      childCurrent: widget,
                                      child: MainScreen(),
                                      type: PageTransitionType.topToBottomJoined
                                    ),
                                  );
                                }
                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                        registerRes,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    )
                                  );
                                }
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
              ),
            ),
          );
        }
      ),
    );
  }
}
