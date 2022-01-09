import 'package:geohashlib/geohashlib.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireUser {
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

class VoiceChat {
  VoiceChat();
}

class TextChat {
  TextChat();
}

class Spot {
  final GeoHash geohash;
  final Latitude lat;
  final Longitude lon;
  final String name;
  final String locationName1;
  final String locationName2;
  final String locationName3;
  final String locationNameHurigana;
  final Timestamp timestamp;
  final List<VoiceChat> voiceChat;
  final List<TextChat> textChat;

  Spot(
      this.geohash,
      this.lat,
      this.lon,
      this.timestamp,
      this.name,
      this.locationName1,
      this.locationName2,
      this.locationName3,
      this.locationNameHurigana,
      {this.voiceChat = const [],
      this.textChat = const []});
  static Spot fromMap(Map<String, dynamic> obj) {
    return new Spot(
      obj["geohash"],
      obj["lat"],
      obj["lng"],
      obj["timestamp"],
      obj["name"],
      obj["locationName1"],
      obj["locationName2"],
      obj["locationName3"],
      obj["locationNameHurigana"],
    );
  }
}
