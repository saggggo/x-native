import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../api/firestore.dart';
import 'error.dart';
import 'nearby/routes.dart';
import 'home/routes.dart';
import 'profile/routes.dart';
import 'location/routes.dart';
import "../components/loading.dart";
import "../utils/presence_manager.dart";
import "./nearby/nearby.dart";

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class Entry extends StatelessWidget {
  bool initialized = false;

  void _init(BuildContext ctx) {
    var user = ctx.read<FireUser>();

    if (!initialized) {
      PresenceManager(user.uid);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        Map<String, dynamic> data = message.data;

        print(data);
      });
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      this.initialized = true;
    }
  }

  @override
  build(BuildContext ctx) {
    _init(ctx);
    return CupertinoApp(
      theme: CupertinoThemeData(
          brightness: Brightness.dark, primaryColor: Color(0xFFFFFFFF)),
      home: Frame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Frame extends StatelessWidget {
  final CupertinoTabController _tabController = CupertinoTabController();

  Future<void> _refreshPushTokenHandler(String uid) {
    Future<void> _saveTokenToDatabase(String? _token) {
      return FireUser.update(uid, {
        'tokens': FieldValue.arrayUnion([_token]),
      });
    }

    return FirebaseMessaging.instance.getToken().then((token) {
      return _saveTokenToDatabase(token);
    }).then((value) =>
        FirebaseMessaging.instance.onTokenRefresh.listen(_saveTokenToDatabase));
  }

  Widget build(BuildContext ctx) {
    var user = ctx.read<FireUser>();

    return FutureBuilder(
      future: this._refreshPushTokenHandler(user.uid),
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        print("state: " + snapshot.connectionState.toString());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return NearByPage();
        } else {
          // TODO
          return Loading();
        }
      },
    );
  }
}
