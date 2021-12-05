import 'package:flutter/cupertino.dart';
import "./nearby.dart";

class NearbyRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(routes: <String, WidgetBuilder>{
      "/": (BuildContext ctx) {
        return NearbyPage();
      },
    });
  }
}
