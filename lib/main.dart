import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/screens/registerScreen.dart';
import 'package:moneymattersmobile/widgets/screenFormat.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff191720),
      ),
      home: RegisterScreen(),
    );
  }

}

class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

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

  //navbar Themes

  @override
  Widget build(BuildContext context) {

    return ScreenFormat(
      TabBarView(
        controller: tc,
        children: pageData.map<Widget>((e) => e.screen).toList(),
      ),
      tc: tc,
      appBarLogo: RichText(
        text: const TextSpan(
          style: TextStyle(fontSize: 25.0,),
          children: <TextSpan>[
            TextSpan(text: 'Money', style: TextStyle(color: Colors.green)),
            TextSpan(text: 'Matters'),
          ],
        ),
      ),
    );
  }
}