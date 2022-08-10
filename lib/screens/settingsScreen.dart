import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/providers/themeProvider.dart';
import 'package:moneymattersmobile/screens/editProfileScreen.dart';
import 'package:moneymattersmobile/screens/registerScreen.dart';
import 'package:moneymattersmobile/screens/signInScreen.dart';
import 'package:moneymattersmobile/services/auth.dart';
import 'package:moneymattersmobile/services/firestore.dart';
import 'package:moneymattersmobile/services/storage.dart';
import 'package:moneymattersmobile/widgets/screenFormat.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final form = GlobalKey<FormState>();
  User? currUser;
  String userPfp = "";

  void getUserInfo() {
    getCurrUser().then((value) => setState(() {currUser = value;}));
    getPfpLink().then((value) => setState(() {userPfp = value ?? "";}));
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<ThemeProvider>(context).theme == ThemeMode.dark;
    return ScreenFormat(
      currUser == null ?
        const Center(child: CircularProgressIndicator())
      : Form(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  // color: textColor,
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
                    Navigator.push(
                      context,
                      PageTransition(
                        childCurrent: widget,
                        child: EditProfileScreen(getUserInfo: getUserInfo),
                        type: PageTransitionType.topToBottomJoined,
                      ),
                    );
                  },
                  title: Text(currUser?.username ?? "Guest",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    )),
                  leading: currUser != null && (currUser?.pfp ?? "").isNotEmpty ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        userPfp,
                        width: 25,
                        height: 25,
                        fit: BoxFit.cover,
                      ),
                    ) :
                    Icon(
                      Icons.account_circle_outlined,
                      size: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                  trailing: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                elevation: 8.0,
              ),
              const SizedBox(height: 40),
              Row(
                children: const [
                  Icon(
                    Icons.settings,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "General",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                    children: const [
                      Icon(
                        Icons.nightlight,
                        color: Colors.green,
                      ),
                      Text(
                        "Dark mode",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // color: textColor,
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
                          SharedPreferences.getInstance().then((prefs) => prefs.setBool("darkMode", val));
                          Provider.of<ThemeProvider>(context, listen: false).toggleTheme(darkMode);
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
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      side: const BorderSide(color: Colors.red,),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2.2,
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () {
                      signOut();
                      deleteUser(currUser?.id ?? "");
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          childCurrent: widget,
                          child: RegisterScreen(),
                          type: PageTransitionType.topToBottomJoined
                        ),
                        (route) => false
                      );
                    }
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      // side: BorderSide(color: textColor,),
                    ),
                    onPressed: () {
                      signOut();
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
                        // color: textColor,
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
      logo: false,
    );
  }
}
