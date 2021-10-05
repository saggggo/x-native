import 'package:flutter/cupertino.dart';
import 'profile.dart';
import 'settings.dart';
import 'profile_editing.dart';

class ProfileRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(routes: <String, WidgetBuilder>{
      "/": (BuildContext ctx) {
        return ProfilePage();
      },
      "/editing": (BuildContext ctx) {
        return ProfileEditingPage();
      },
      "/settings": (BuildContext ctx) {
        return SettingsPage();
      }
    });
  }
}
