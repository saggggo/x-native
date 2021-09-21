import 'dart:developer';
import 'package:flutter/cupertino.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:permission_handler/permission_handler.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geolocator/geolocator.dart' as GeoLocator;
import '../../components/error_dialog.dart';
import '../fullscreen/shiga_waiting.dart';
import '../../api/api.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("home screen");

    return CupertinoPageScaffold(
        child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CupertinoButton(
          child: Text('Shiga'),
          onPressed: () async {
            await Permission.location.request();
            var status = await Permission.location.status;
            if (status.isGranted) {
              await _determinePosition().then((position) {
                return createTicket(age: 20, gender: "male");
              }).catchError((e) {
                print(e);
                locationError(context, e.message);
              }).then((createTicketResponse) {
                Navigator.of(context, rootNavigator: true).popAndPushNamed(
                    "/waiting",
                    arguments: ShigaWaitingArguments(createTicketResponse.id));
              }).catchError((e) {
                print(e);
                errorDialog(context, "ネットワークエラー", "ネットワークの接続を確認してください");
              });
            } else if (status.isDenied || status.isPermanentlyDenied) {
              openAppSettings();
            } else {
              permissionError(
                  context, "current permission: " + status.toString());
            }
          },
        ),
        CupertinoButton(
          child: Text('Test'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).popAndPushNamed(
                "/waiting",
                arguments: ShigaWaitingArguments("xxx"));
          },
        ),
      ]),
    ));
  }

  Future<GeoLocator.Position> _determinePosition() async {
    bool serviceEnabled;

    serviceEnabled = await GeoLocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    return await GeoLocator.Geolocator.getCurrentPosition();
  }
}
