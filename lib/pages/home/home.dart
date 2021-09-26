import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart' as GeoLocator;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CupertinoButton(
          child: Text('Press!!'),
          onPressed: () async {},
        ),
        CupertinoButton(
          child: Text('Test'),
          onPressed: () {},
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
