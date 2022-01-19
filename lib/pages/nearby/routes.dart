import 'package:flutter/cupertino.dart';
import "./nearby.dart";
import "./create_voice_chat.dart";
import "./detail_voice_chat.dart";

class NearbyRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(routes: <String, WidgetBuilder>{
      "/": (BuildContext ctx) {
        return NearbyPage();
      },
      "/voiceChat/create": (BuildContext ctx) {
        return CreateVoiceChatForm();
      },
      "/voiceChat/detail": (BuildContext ctx) {
        return DetailVoiceChat();
      }
    });
  }
}
