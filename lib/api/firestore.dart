import 'package:json_annotation/json_annotation.dart';

part 'firestore.g.dart';

@JsonSerializable()
class FireUser {
  final String uid;
  final String email;
  final bool emailVerified;
  final String? ticketId;
  final bool disabled;
  final String? phoneNumber;
  final int ermainingLives;
  @JsonKey(name: 'remainingLives_free')
  final int remainingLivesFree;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'modified_at')
  final String modifiedAt;

  FireUser(
      {required this.uid,
      required this.email,
      required this.emailVerified,
      this.ticketId,
      required this.disabled,
      this.phoneNumber,
      required this.ermainingLives,
      required this.remainingLivesFree,
      required this.createdAt,
      required this.modifiedAt});
  factory FireUser.fromJson(Map<String, dynamic> json) =>
      _$FireUserFromJson(json);
  Map<String, dynamic> toJson() => _$FireUserToJson(this);
}

@JsonSerializable()
class FireUserProfile {
  final int? age;
  final String? city;
  final String? displayName;
  final String? gender;
  final String? language;
  final String? photoURL;
  final String? introduce;

  FireUserProfile({
    this.age,
    this.city,
    this.displayName,
    this.gender,
    this.language,
    this.photoURL,
    this.introduce,
  });
  factory FireUserProfile.fromJson(Map<String, dynamic> json) =>
      _$FireUserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$FireUserProfileToJson(this);
}
