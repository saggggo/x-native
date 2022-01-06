import 'package:geohashlib/geohashlib.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
