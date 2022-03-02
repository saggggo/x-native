import 'package:flutter/material.dart';
import "./location.dart";
import "./create_voice_chat.dart";
import "./detail_voice_chat.dart";

class LocationRoutes extends StatelessWidget {
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
                ret = LocationPage();
                break;
              case "/voiceChat/create":
                ret = CreateVoiceChatForm();
                break;
              case "/voiceChat/detail":
                ret = DetailVoiceChat();
            }
            return ret;
          },
        );
      },
    );
  }
}
