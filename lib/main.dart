import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/screens/addTasnactionScreen.dart';
import 'package:moneymattersmobile/screens/home.dart';
import 'package:moneymattersmobile/screens/registerScreen.dart';
import 'package:moneymattersmobile/screens/reportsScreen.dart';
import 'package:moneymattersmobile/screens/signInScreen.dart';
import 'package:moneymattersmobile/widgets/screenFormat.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff191720),
      ),
      home: Auth.FirebaseAuth.instance.currentUser == null ? SignInScreen() : const MainScreen(),
    );
  }

}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

  //for navbar
  List<Widget> pageData = [
    ReportsScreen(),
    HomeScreen(),
    AddTransactionScreen(),
  ];

  late TabController tc;
  int currIndex = 1;
  @override
  void initState() {
    super.initState();
    tc = TabController(
      initialIndex: currIndex,
      length: pageData.length,
      vsync: this
    );
    tc.addListener(() { setState(() { currIndex = tc.index; }); });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFormat(
      TabBarView(
        controller: tc,
        children: pageData,
      ),
      tc: tc,
    );
  }
}