import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moneymattersmobile/main.dart';
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/screens/registerScreen.dart';
import 'package:moneymattersmobile/services/firebase.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/registerSignInPassword.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/registerSignInTextField.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/regsterSignInButton.dart';
import 'package:page_transition/page_transition.dart';

class SignInScreen extends StatefulWidget {
  String? username, password;

  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> form = GlobalKey<FormState>();
  bool passwordObscurity = true;
  List<User> userList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: readUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          userList = snapshot.data!;
        }
        else if (snapshot.hasError) {
          print(snapshot.error);
        }
        return Scaffold(
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
          body: GestureDetector(
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
                                          TextInputType.text,
                                          "Username",
                                          (val) { widget.username = val!; },
                                          (val) => null,
                                        ),
                                        RegisterSignInPassword(
                                          passwordObscurity,
                                          () => setState(() { passwordObscurity = !passwordObscurity; }),
                                          (val) { widget.password = val!; },
                                          (val) => null,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
          
                            //Google sign in button (WIP)
          
                            // ElevatedButton.icon(
                            //   style: ElevatedButton.styleFrom(
                            //     primary: Colors.white,
                            //     onPrimary: Colors.black,
                            //     maximumSize: const Size(double.infinity, 60),
                            //     minimumSize: const Size(double.infinity, 60),
                            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            //   ),
                            //   onPressed: () {},
                            //   icon: FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                            //   label: Text("Sign Up with Google"),
                            // ),
          
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account? ", style: bodyText,),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: RegisterScreen(),
                                          childCurrent: widget,
                                          type: PageTransitionType.leftToRightJoined
                                      )
                                    );
                                  },
                                  child: Text("Register", style: bodyText.copyWith(color: Colors.white),),
                                )
                              ],
                            ),
                            RegisterSignInButton(
                              "Sign In",
                              () async {
                                Auth.FirebaseAuth auth = Auth.FirebaseAuth.instance;
                                if (form.currentState!.validate()) {
                                  form.currentState!.save();
                                  User? getUserByUsername = userList.any((user) => user.username == widget.username) ?
                                    userList.where((user) => user.username == widget.username).toList()[0] : null;
                                  
                                  if (getUserByUsername != null) {
                                    try {
                                      Auth.UserCredential userCredential = await auth.signInWithEmailAndPassword(
                                        email: getUserByUsername.email,
                                        password: widget.password!,
                                      );
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                            childCurrent: widget,
                                            child: MainScreen(),
                                            type: PageTransitionType.topToBottomJoined
                                        ),
                                      );
                                    } on Auth.FirebaseAuthException catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                            e.message ?? "",
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        )
                                      );
                                    }
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
                )),
          ),
        );
      }
    );
  }
}