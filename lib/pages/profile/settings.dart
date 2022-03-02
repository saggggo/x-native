import 'dart:developer';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import '../../api/firestore.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = context.read<FireUser>();
    inspect(user);

    return Scaffold(
        // navigationBar: CupertinoNavigationBar(
        //   middle: Text("設定"),
        // ),
        body: SettingsList(
      sections: [
        SettingsSection(
          title: 'Profile',
          tiles: [
            SettingsTile(
              title: 'email',
              subtitle: user.email,
              leading: Icon(Icons.home),
            ),
            SettingsTile(
              title: 'phone number',
              subtitle: user.phoneNumber,
              leading: Icon(Icons.home),
            ),
          ],
        ),
        SettingsSection(
          title: 'General',
          tiles: [
            SettingsTile(
              title: 'Language',
              subtitle: 'English',
              leading: Icon(Icons.home),
              onPressed: (BuildContext context) {},
            ),
            SettingsTile.switchTile(
              title: 'Use fingerprint',
              leading: Icon(Icons.home),
              switchValue: false,
              onToggle: (bool value) {},
            ),
          ],
        ),
        SettingsSection(
          title: 'other',
          tiles: [
            SettingsTile(
              title: 'privacy policy',
              onPressed: (BuildContext context) {},
            ),
            SettingsTile(
              title: 'term and use',
            ),
            SettingsTile(
              title: 'license',
            ),
            SettingsTile(
              title: 'about',
            ),
          ],
        ),
        SettingsSection(
          title: 'Warning',
          tiles: [
            SettingsTile(
                title: "Logout",
                onPressed: (ctx) {
                  FirebaseAuth.instance.signOut();
                })
          ],
        )
      ],
    ));
  }
}
