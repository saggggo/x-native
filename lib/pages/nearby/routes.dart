import 'package:flutter/material.dart';
import "./nearby.dart";
import "../error.dart";

class NearByRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: "/",
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            late Widget ret;
            switch (settings.name) {
              case "/":
                ret = NearByPage();
                break;
            }
            return ret;
          },
        );
      },
    );
  }
}
