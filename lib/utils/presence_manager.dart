// PresenceManager
// see also: https://firebase.google.com/docs/firestore/solutions/presence?hl=ja

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class PresenceManager {
  static PresenceManager? _singleton;
  static var _offline = {
    "state": "offline",
    "last_changed": ServerValue.timestamp
  };
  static var _online = {
    "state": "online",
    "last_cahnged": ServerValue.timestamp
  };
  static var _isOfflineForFirestore = {
    "state": 'offline',
    "last_changed": FieldValue.serverTimestamp(),
  };

  static var _isOnlineForFirestore = {
    "state": 'online',
    "last_changed": FieldValue.serverTimestamp(),
  };

  final String userId;
  final DatabaseReference userstatusReference;
  String? lastLocation;

  factory PresenceManager(String userId) {
    if (_singleton != null) {
      if (userId != _singleton!.userId) {
        throw new Exception("useId is unmatch.");
      }
      return _singleton!;
    } else {
      _singleton = PresenceManager._internal(
          userId, database.ref("/userpresence/" + userId));
      _singleton!._init();
      return _singleton!;
    }
  }

  PresenceManager._internal(this.userId, this.userstatusReference);

  void updateLocation(String location) {
    this.lastLocation = location;
  }

  void _init() {
    database.ref(".info/connected").onValue.listen((event) {
      if (event.snapshot.value == false) {
        firestore.doc("/userpresence/" + userId).set(_isOfflineForFirestore);
        return;
      }
      userstatusReference.onDisconnect().set(_offline).then((v) {
        userstatusReference.set(_online);
        firestore.doc("/userpresence/" + userId).set(_isOnlineForFirestore);
      });
    });
  }
}
