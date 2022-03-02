import 'package:flutter/material.dart';
import 'home.dart';
import 'useradd.dart';

class HomeRoutes extends StatelessWidget {
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
                ret = HomePage();
                break;
              case "/useradd":
                ret = UserAddPage();
                break;
            }
            return ret;
          },
        );
      },
    );
  }
}
