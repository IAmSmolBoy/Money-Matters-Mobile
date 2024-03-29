import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moneymattersmobile/main.dart';
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/providers/themeProvider.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/screens/registerScreen.dart';
import 'package:moneymattersmobile/screens/resetPasswordScreen.dart';
import 'package:moneymattersmobile/services/auth.dart';
import 'package:moneymattersmobile/services/firestore.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/registerSignInPassword.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/registerSignInTextField.dart';
import 'package:moneymattersmobile/widgets/registerSignInWidgets/regsterSignInButton.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    readUsers().then((value) => setState(() {userList = value;}));
    Future.delayed(const Duration(seconds: 3), () => setState(() => splashScreen = false));
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      SharedPreferences.getInstance().then((prefs) {
        bool darkMode = prefs.getBool("darkMode") ?? true;
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme(darkMode);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return splashScreen ? Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Center(
          child: SizedBox(
            child: Image.asset(
              "images/Splash Screen Logo.png",
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height - 10,
            ),
          )
        ),
      ),
    ) : Scaffold(
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
                                      TextInputType.text,
                                      "Username",
                                      (val) { widget.username = val!; },
                                      (val) => val == null ? "Please enter your username" : null,
                                    ),
                                    RegisterSignInPassword(
                                      passwordObscurity,
                                      () => setState(() { passwordObscurity = !passwordObscurity; }),
                                      (val) { widget.password = val!; },
                                      (val) => val == null ? "Please enter your password" : null,
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
                            Text("Forgot your password? ", style: bodyText,),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero
                              ),
                              onPressed: () {
                                Navigator.push(context, PageTransition(
                                  child: ForgetPasswordScreen(),
                                  type: PageTransitionType.topToBottomJoined,
                                  childCurrent: widget
                                ));
                              },
                              child: Text("Reset it.", style: bodyText,),
                            )
                          ],
                        ),
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
                              child: Text("Register", style: bodyText,),
                            )
                          ],
                        ),
                        RegisterSignInButton(
                          "Sign In",
                          () async {
                            if (form.currentState!.validate()) {
                              form.currentState!.save();
                              User? getUserByUsername = userList.any((user) => user.username == widget.username) ?
                                userList.where((user) => user.username == widget.username).toList()[0] : null;
                              
                              if (getUserByUsername != null) {
                                String res = await login(getUserByUsername.email, widget.password!);
                                if (res == "Success") {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        childCurrent: widget,
                                        child: MainScreen(),
                                        type: PageTransitionType.topToBottomJoined
                                    ),
                                  );
                                }
                                else  {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                        res,
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
}