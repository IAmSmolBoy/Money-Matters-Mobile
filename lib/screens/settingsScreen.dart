import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/screens/editProfileScreen.dart';
import 'package:moneymattersmobile/screens/signInScreen.dart';
import 'package:moneymattersmobile/widgets/screenFormat.dart';
import 'package:page_transition/page_transition.dart';

class SettingsScreen extends StatefulWidget {

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final form = GlobalKey<FormState>();

  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return ScreenFormat(
      Form(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: ListView(
            children: [
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                margin: EdgeInsets.zero,
                color: const Color(0xFF495057),
                child: ListTile(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        childCurrent: widget,
                        child: EditProfileScreen(),
                        type: PageTransitionType.topToBottomJoined,
                      ),
                      (route) => false
                    );
                  },
                  title: Text(currUser?.username ?? "Guest",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    )),
                  leading: Icon(
                    Icons.account_circle_outlined,
                    color: textColor,
                  ),
                  trailing: Icon(Icons.edit,
                    color: textColor,),
                ),
                elevation: 8.0,
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Icon(
                    Icons.settings,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "General",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 15,
                thickness: 2,
                color: Color(0xFFADB5BD),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.nightlight,
                        color: Colors.green,
                      ),
                      Text(
                        "Dark mode",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: darkMode,
                      onChanged: (bool val) {
                        setState(() {
                          darkMode = val;
                        });
                      }
                    )
                  )
                ],
              ),
              const SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      side: BorderSide(color: textColor,),
                    ),
                    onPressed: () {
                      currUser = null;
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          childCurrent: widget,
                          child: SignInScreen(),
                          type: PageTransitionType.bottomToTopJoined,
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2.2,
                        color: textColor,
                      ),
                    ),
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
      settings: false,
    );
  }
}
