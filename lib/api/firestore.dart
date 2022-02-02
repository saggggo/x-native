import "dart:developer";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geohashlib/geohashlib.dart';

final _firestore = FirebaseFirestore.instance;

Timestamp now() {
  var _now = DateTime.now().microsecondsSinceEpoch;
  return Timestamp((_now / 1000000).floor(), _now % 1000000 * 1000);
}

class FireUser {
  static String keyName = "users";
  final String uid;
  final String email;
  final bool emailVerified;
  final bool disabled;
  final Timestamp createdAt;
  final Timestamp modifiedAt;
  final String? phoneNumber;

  FireUser(
      {required this.uid,
      required this.email,
      required this.emailVerified,
      required this.disabled,
      this.phoneNumber,
      required this.createdAt,
      required this.modifiedAt});

  FireUser.from(Map<String, dynamic> obj)
      : this.uid = obj["uid"] as String,
        this.email = obj["email"] as String,
        this.emailVerified = obj["emailVerified"] as bool,
        this.disabled = obj["disabled"] as bool,
        this.createdAt = obj["createdAt"] as Timestamp,
        this.modifiedAt = obj["modifiedAt"] as Timestamp,
        this.phoneNumber = obj["phoneNumber"] as String?;

  static Future<void> update(String userId, Map<String, dynamic> obj) {
    return _firestore.collection(FireUser.keyName).doc(userId).update(obj);
  }
}

class FireUserProfile {
  final String displayName;
  final String? photoURL;

  FireUserProfile({
    required this.displayName,
    this.photoURL,
  });

  FireUserProfile.from(Map<String, dynamic> obj)
      : this.displayName = obj["displayName"],
        this.photoURL = obj["photoURL"];
}

class Spot {
  static String keyName = "spots";
  final GeoHash geohash;
  final Latitude lat;
  final Longitude lon;
  final String name;
  final String locationName1;
  final String locationName2;
  final String locationName3;
  final String locationNameHurigana;
  final Timestamp timestamp;

  // Spot({
  //   required this.geohash,
  //   required this.lat,
  //   required this.lon,
  //   required this.timestamp,
  //   required this.name,
  //   required this.locationName1,
  //   required this.locationName2,
  //   required this.locationName3,
  //   required this.locationNameHurigana,
  // });

  Spot.from(Map<String, dynamic> obj)
      : this.geohash = obj["geohash"],
        this.lat = obj["lat"],
        this.lon = obj["lng"],
        this.timestamp = obj["timestamp"],
        this.name = obj["name"],
        this.locationName1 = obj["locationName1"],
        this.locationName2 = obj["locationName2"],
        this.locationName3 = obj["locationName3"],
        this.locationNameHurigana = obj["locationNameHurigana"];

  static Future<Spot> get(String geohash) {
    return _firestore.collection(keyName).doc(geohash).get().then((doc) {
      var data = doc.data();
      if (data != null) {
        try {
          return Spot.from(data);
        } catch (e) {
          print(e);
          return Future.error(e);
        }
      } else {
        return Future.error("data is null");
      }
    });
  }

  static Future<List<Spot>> search(GeoHash start, GeoHash end) {
    return _firestore
        .collection(keyName)
        .orderBy("geohash")
        .startAt([start])
        .endAt([end])
        .get()
        .then((snapshot) {
          var docs = snapshot.docs;
          List<Spot> spots = [];
          docs.forEach((d) {
            try {
              spots.add(Spot.from(d.data()));
            } catch (e) {
              print(e);
            }
          });
          return spots;
        });
  }

  Future<List<VoiceChat>> listVoiceChat() {
    return _firestore
        .collection(keyName)
        .doc(geohash)
        .collection(VoiceChat.keyName)
        .orderBy("createdAt", descending: true)
        .limit(10)
        .get()
        .then((snapshot) {
      var docs = snapshot.docs;
      print(docs.length);
      List<VoiceChat> vcs = [];
      docs.forEach((vc) {
        try {
          vcs.add(VoiceChat.from(vc.data()));
        } catch (e) {
          print(e);
        }
      });
      return vcs;
    });
  }
}

typedef ChatId = String;

class VoiceChat {
  static final String keyName = "voiceChat";

  final GeoHash geohash;
  final String title;
  final String owner;
  final int maxAtendees;
  final List<String> members;
  final Timestamp createdAt;

  // VoiceChat({
  //   required this.geohash,
  //   required this.owner,
  //   required this.maxAtendees,
  //   required this.members,
  //   required this.createdAt,
  // });

  VoiceChat.from(Map<String, dynamic> obj)
      : this.geohash = obj["geohash"],
        this.title = obj["title"],
        this.owner = obj["owner"],
        this.maxAtendees = obj["maxAtendees"],
        this.members = obj["members"] = obj["members"].cast<String>(),
        this.createdAt = obj["createdAt"];

  static Future<ChatId> create(String geohash, Map<String, Object?> data) {
    return _firestore
        .collection(Spot.keyName)
        .doc(geohash)
        .collection(keyName)
        .add(data)
        .then((res) => res.id);
  }

  static Future<VoiceChat> get(String geohash, ChatId chatId) {
    return _firestore
        .collection(Spot.keyName)
        .doc(geohash)
        .collection(keyName)
        .doc(chatId)
        .get()
        .then((doc) {
      var data = doc.data();
      if (data != null) {
        try {
          return VoiceChat.from(data);
        } catch (e) {
          print(e);
          return Future.error(e);
        }
      } else {
        return Future.error("data is null");
      }
    });
  }

  static Future<void> update(
      String geohash, ChatId chatId, Map<String, Object?> data) {
    return _firestore
        .collection(Spot.keyName)
        .doc(geohash)
        .collection(keyName)
        .doc(chatId)
        .update(data);
  }

  static void listen(
      String geohash, ChatId chatId, void Function(VoiceChat) listener) {
    _firestore
        .collection("spots")
        .doc(geohash)
        .collection("voiceChat")
        .doc(chatId)
        .snapshots()
        .listen((doc) {
      var data = doc.data();
      if (data != null) {
        listener(data as VoiceChat);
      }
    });
  }
}

class TextChat {
  static final keyName = "textChat";

  final GeoHash geohash;
  final String owner;
  final Timestamp createdAt;

  TextChat({
    required this.geohash,
    required this.owner,
    required this.createdAt,
  });

  static Future<TextChat> get(String geohash, ChatId chatId) {
    return _firestore
        .collection(Spot.keyName)
        .doc(geohash)
        .collection(keyName)
        .doc(chatId)
        .get()
        .then((doc) => doc.data() as TextChat);
  }
}
