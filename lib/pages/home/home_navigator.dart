import 'package:flutter/cupertino.dart';
import 'home.dart';
import 'waiting.dart';

class HomeNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(routes: <String, WidgetBuilder>{
      "/": (BuildContext ctx) {
        return HomePage();
      },
      "/waiting": (BuildContext ctx) {
        return WaitingPage();
      }
    });
  }
}
