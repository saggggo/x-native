import 'dart:async';

import 'package:flutter/material.dart';
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
import 'fullscreen/full_screen_test.dart';
import "../components/loading.dart";
import "../utils/presence_manager.dart";
import "./theme.dart";
import "./testpage.dart";

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
    return MaterialApp(
      theme: myTheme,

      // theme: CupertinoThemeData(
      //     brightness: Brightness.dark, primaryColor: Color(0xFFFFFFFF)),
      routes: <String, WidgetBuilder>{
        "/": (BuildContext ctx) {
          return _RefreshTokenManager();
        },
        "/fullscreen": (BuildContext ctx) {
          return FullScreenTest();
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class _RefreshTokenManager extends StatelessWidget {
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

  @override
  Widget build(BuildContext ctx) {
    var user = ctx.read<FireUser>();
    return FutureBuilder(
      future: this._refreshPushTokenHandler(user.uid),
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        print("state: " + snapshot.connectionState.toString());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else {
          return _Frame();
        }
      },
    );
  }
}

class _Frame extends StatefulWidget {
  const _Frame({Key? key}) : super(key: key);

  @override
  State<_Frame> createState() => _FrameState();
}

class _FrameState extends State<_Frame> {
  static List<Widget> _routes = <Widget>[
    HomeRoutes(),
    // return TestPage();
    NearByRoutes(),
    LocationRoutes(),
    ProfileRoutes()
  ];
  int tabIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  Widget build(BuildContext ctx) {
    return Scaffold(
      body: _routes.elementAt(tabIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: "ホーム", icon: Icon(Ionicons.home_outline, size: 24)),
          BottomNavigationBarItem(
              label: "近く",
              icon: Icon(Ionicons.navigate_circle_outline, size: 24)),
          // BottomNavigationBarItem(
          //     label: "録音", icon: Icon(Ionicons.mic_outline, size: 24)),
          BottomNavigationBarItem(
              label: "マップ", icon: Icon(Ionicons.location_outline, size: 24)),
          BottomNavigationBarItem(
              label: "プロフィール", icon: Icon(Ionicons.id_card_outline, size: 24))
        ],
        iconSize: 25,
        currentIndex: tabIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
