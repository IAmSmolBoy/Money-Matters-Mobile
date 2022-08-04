import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:moneymattersmobile/providers/themeProvider.dart';
import 'package:moneymattersmobile/screens/addTasnactionScreen.dart';
import 'package:moneymattersmobile/screens/home.dart';
import 'package:moneymattersmobile/screens/reportsScreen.dart';
import 'package:moneymattersmobile/screens/signInScreen.dart';
import 'package:moneymattersmobile/services/auth.dart';
import 'package:moneymattersmobile/widgets/screenFormat.dart';
import 'package:provider/provider.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

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