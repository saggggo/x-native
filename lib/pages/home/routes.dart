import 'package:flutter/cupertino.dart';
import 'home.dart';
import 'useradd.dart';

class HomeRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(defaultTitle: "ss", routes: <String, WidgetBuilder>{
      "/": (BuildContext ctx) {
        return HomePage();
      },
      "/useradd": (BuildContext ctx) {
        return UserAddPage();
      }
    });
  }
}
