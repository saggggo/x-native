import 'package:flutter/cupertino.dart';
import "./friends.dart";
import "../error.dart";

class FriendsRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(routes: <String, WidgetBuilder>{
      "/": (BuildContext ctx) {
        return FriendsPage();
      },
    });
  }
}
