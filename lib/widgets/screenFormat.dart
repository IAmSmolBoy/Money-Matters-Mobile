import 'package:flutter/material.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/screens/settingsScreen.dart';
import 'package:moneymattersmobile/widgets/bottomNavBar.dart';
import 'package:page_transition/page_transition.dart';

class ScreenFormat extends StatelessWidget {
  TabController? tc;
  Widget childWidget;
  bool settings, logo;
  void Function()? settingsFunc;
  ScreenFormat(this.childWidget, {this.settings = true, this.logo = true, this.tc, this.settingsFunc, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 40, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                logo ?
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 25.0,),
                    children: <TextSpan>[
                      const TextSpan(text: 'Money', style: TextStyle(color: Colors.green)),
                      TextSpan(text: 'Matters', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                ) :
                IconButton(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                  // color: textColor,
                  onPressed: () { Navigator.pop(context); },
                  icon: const Icon(Icons.arrow_back),
                ),
                settings ? IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    settingsFunc != null ? settingsFunc!() : Navigator.push(context, PageTransition(
                      child: SettingsScreen(),
                      childCurrent: this,
                      type: PageTransitionType.topToBottom,
                      duration: const Duration(milliseconds: 200),
                      reverseDuration: const Duration(milliseconds: 200),
                    ));
                  },
                  icon: Icon(
                    Icons.settings,
                    // color: textColor,
                  )
                ) : const SizedBox()
              ],
            ),
          ),
          Expanded(
            child: childWidget,
          ),
        ]
      ),
      bottomNavigationBar: tc != null ? BottomNavBar(tc!) : null,
    );
  }
}
