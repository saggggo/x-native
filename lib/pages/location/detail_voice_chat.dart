import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../api/firestore.dart';
import '../../components/loading.dart';
import "../../utils/webrtc.dart";

class DetailVoiceChat extends StatefulWidget {
  const DetailVoiceChat({Key? key}) : super(key: key);

  @override
  _DetailVoiceChatFormState createState() {
    return _DetailVoiceChatFormState();
  }
}

class _DetailVoiceChatFormState extends State<DetailVoiceChat> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var user = context.read<FireUser>();
    final voiceChat = ModalRoute.of(context)!.settings.arguments as VoiceChat;
    return Scaffold(
      body: SafeArea(
          child: (loading)
              ? Loading()
              : Column(
                  children: [
                    Container(child: Text("hoge")),
                    Container(child: Text("hoge")),
                    Container(child: Text("hoge"))
                  ],
                )),
    );
  }
}
