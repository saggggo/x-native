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
  final String? displayName;
  final String? photoURL;

  FireUserProfile({
    this.displayName,
    this.photoURL,
  });

  FireUserProfile.from(Map<String, dynamic> obj)
      : this.displayName = obj["displayName"],
        this.photoURL = obj["photoURL"];
}
