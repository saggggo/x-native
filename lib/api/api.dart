// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_functions/cloud_functions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api.g.dart';

FirebaseFunctions functions = FirebaseFunctions.instance;

@JsonSerializable()
class CreateTime {
  final int nanos;
  final int seconds;

  CreateTime({required this.nanos, required this.seconds});
  factory CreateTime.fromJson(Map<String, dynamic> json) =>
      _$CreateTimeFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTimeToJson(this);
}

@JsonSerializable()
class StringArgs {
  final String expectAge;
  final String age;
  final String userId;
  final String gender;

  StringArgs(
      {required this.expectAge,
      required this.age,
      required this.userId,
      required this.gender});
  factory StringArgs.fromJson(Map<String, dynamic> json) =>
      _$StringArgsFromJson(json);
  Map<String, dynamic> toJson() => _$StringArgsToJson(this);
}

@JsonSerializable()
class SearchFields {
  @JsonKey(name: 'string_args')
  final StringArgs stringArgs;
  final List<String> tags;

  SearchFields({required this.stringArgs, required this.tags});
  factory SearchFields.fromJson(Map<String, dynamic> json) =>
      _$SearchFieldsFromJson(json);
  Map<String, dynamic> toJson() => _$SearchFieldsToJson(this);
}

@JsonSerializable()
class CreateTicketResponse {
  @JsonKey(name: 'create_time')
  final CreateTime createTime;
  final String id;
  @JsonKey(name: 'search_fields')
  final SearchFields searchFields;

  CreateTicketResponse(
      {required this.createTime, required this.id, required this.searchFields});
  factory CreateTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateTicketResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTicketResponseToJson(this);
}

Future<CreateTicketResponse> createTicket(
    {required int age, required String gender}) {
  var callable = functions.httpsCallable("createTicket");
  return callable.call(<String, dynamic>{
    'age': age,
    'gender': gender,
    'location': gender
  }).then((value) {
    print(value.data.toString());
    return CreateTicketResponse.fromJson(
        new Map<String, dynamic>.from(value.data));
  });
}

@JsonSerializable()
class MatchingInfo {
  @JsonKey(name: 'Deadline')
  final int deadline;
  @JsonKey(name: 'Female')
  final int female;
  @JsonKey(name: 'Male')
  final int male;

  MatchingInfo(
      {required this.deadline, required this.female, required this.male});
  factory MatchingInfo.fromJson(Map<String, dynamic> json) =>
      _$MatchingInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MatchingInfoToJson(this);
}

@JsonSerializable()
class Assignment {
  final String connection;

  Assignment({required this.connection});
  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssignmentToJson(this);
}

@JsonSerializable()
class Ticket {
  final String id;
  @JsonKey(name: 'create_time')
  final CreateTime createTime;
  @JsonKey(name: 'search_fields')
  final SearchFields searchFields;
  final Assignment? assignment;

  Ticket(
      {required this.id,
      required this.createTime,
      required this.searchFields,
      this.assignment});
  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
  Map<String, dynamic> toJson() => _$TicketToJson(this);
}

@JsonSerializable()
class GetTicketResponse {
  @JsonKey(name: 'Ticket')
  final Ticket ticket;
  @JsonKey(name: 'MatchingInfo')
  final MatchingInfo matchingInfo;

  GetTicketResponse({required this.ticket, required this.matchingInfo});
  factory GetTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTicketResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetTicketResponseToJson(this);
}

Future<GetTicketResponse> getTicket({required String ticketId}) {
  var callable = functions.httpsCallable("getTicket");
  return callable.call(<String, dynamic>{'ticketId': ticketId}).then((value) {
    print(value.data.toString());
    return GetTicketResponse.fromJson(
        new Map<String, dynamic>.from(value.data));
  });
}

typedef GetTicketTokenResponse = String;
Future<GetTicketTokenResponse> getTicketToken({required String ticketId}) {
  var callable = functions.httpsCallable("getTicketToken");
  return callable.call(<String, dynamic>{'ticketId': ticketId}).then((value) {
    print(value.data.toString());
    return value.data;
  });
}

Future<dynamic> deleteTicket({required String ticketId}) {
  var callable = functions.httpsCallable("deleteTicket");
  return callable.call(<String, dynamic>{'ticketId': ticketId}).then((value) {
    print(value.data.toString());
    return value.data;
  });
}

@JsonSerializable()
class GetFriendRequestResponse {
  final String status; // "SUCCESS" | "FAILED" | "WAITING" | "ERROR"
  final String message;

  GetFriendRequestResponse({required this.status, required this.message});
  factory GetFriendRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$GetFriendRequestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetFriendRequestResponseToJson(this);
}

Future<GetFriendRequestResponse> getFriendRequest({required String matchId}) {
  var callable = functions.httpsCallable("getFriendRequest");
  return callable.call(<String, dynamic>{'matchId': matchId}).then((value) {
    print(value.data.toString());
    return value.data;
  });
}

@JsonSerializable()
class UpdateFriendRequestResponse {
  final String status; // "WAITING" | "FINISHED" | "ERROR";
  final String message;

  UpdateFriendRequestResponse({required this.status, required this.message});
  factory UpdateFriendRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateFriendRequestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateFriendRequestResponseToJson(this);
}

Future<UpdateFriendRequestResponse> updateFriendRequest(
    {required String matchId}) {
  var callable = functions.httpsCallable("updateFriendRequest");
  return callable.call(<String, dynamic>{'matchId': matchId}).then((value) {
    print(value.data.toString());
    return value.data;
  });
}

@JsonSerializable()
class SendMessageResponse {
  final String status; // "SUCCESS" | "FAILED" | "ERROR";
  final String message;

  SendMessageResponse({required this.status, required this.message});
  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageResponseToJson(this);
}
