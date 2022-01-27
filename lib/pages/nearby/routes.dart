import 'package:flutter/cupertino.dart';
import "./nearby.dart";
import "../error.dart";

class NearByRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(routes: <String, WidgetBuilder>{
      "/": (BuildContext ctx) {
        return NearByPage();
      },
    });
  }
}
