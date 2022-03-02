import 'package:flutter/material.dart';
import 'profile.dart';
import 'settings.dart';
import 'profile_editing.dart';

class ProfileRoutes extends StatelessWidget {
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
                ret = ProfilePage();
                break;
              case "/editing":
                ret = ProfileEditingPage();
                break;
              case "/settings":
                ret = SettingsPage();
            }
            return ret;
          },
        );
      },
    );
  }
}
