import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:moneymattersmobile/providers/themeProvider.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/screens/addTasnactionScreen.dart';
import 'package:moneymattersmobile/screens/home.dart';
import 'package:moneymattersmobile/screens/reportsScreen.dart';
import 'package:moneymattersmobile/screens/signInScreen.dart';
import 'package:moneymattersmobile/services/auth.dart';
import 'package:moneymattersmobile/widgets/screenFormat.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({ Key? key }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool splashScreen = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        return MaterialApp(
          themeMode: Provider.of<ThemeProvider>(context).theme,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xffF8F9FA),
            colorScheme: const ColorScheme.light(primary: Color(0xff191720),),
            primaryColor: const Color(0xffF8F9FA),
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: const Color(0xff191720),
            colorScheme: const ColorScheme.dark(primary: Color(0xffF8F9FA),),
            primaryColor: const Color(0xffF8F9FA),
          ),
          home: Auth.FirebaseAuth.instance.currentUser == null ? SignInScreen() : MainScreen(),
        );
      }
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) {
    getCurrUser().then(
      (value) {
        auth.signInWithEmailAndPassword(
          email: value?.email ?? "",
          password: value?.password ?? "",
        );
      }
    );
  }

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
    Future.delayed(const Duration(seconds: 3), () => setState(() =>splashScreen = false));
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      SharedPreferences.getInstance().then((prefs) {
        bool darkMode = prefs.getBool("darkMode") ?? true;
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme(darkMode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return splashScreen ? Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Center(
          child: Image.asset("images/Splash Screen Logo.png")
        ),
      ),
    ) : ScreenFormat(
      TabBarView(
        controller: tc,
        children: pageData,
      ),
      tc: tc,
    );
  }
}