import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class NearbyPageNavigationContents extends StatelessWidget {
  bool tf = false;
  NearbyPageNavigationContents(this.tf);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CupertinoSwitch(
          value: tf,
          onChanged: (val) {
            if (val) {
              Permission.location.status.then((p) {
                print(p);
                if (p.isDenied) {
                  Permission.location.request().then((permission) {
                    print(permission);
                    if (permission.isPermanentlyDenied) {
                      openAppSettings();
                    }
                  });
                }
                tf = true;
              });
            } else {
              tf = false;
            }
          },
        )
      ],
    );
  }
}

class _NearbyPageState extends State<NearbyPage> {
  bool tf = false;
  MapboxMapController? mController;

  void _onMapCreated(MapboxMapController mc) {
    print("map is created");
    mController = mc;
  }

  void _onStyleLoadedCallback() {
    print("loaded");
  }

  void _onUserLocationUpdated(UserLocation location) {
    print(location);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: NearbyPageNavigationContents(tf),
      ),
      child: SafeArea(
        child: Center(
          child: Container(
            color: Color(0xFFFFFFFF),
            child: Stack(
              alignment: const Alignment(0.9, -0.9),
              children: [
                MapboxMap(
                  // styleString: MapboxStyles.DARK,
                  styleString:
                      "mapbox://styles/saggggo/ckwrw7sfv2djb14o6gubjx42t",
                  initialCameraPosition: const CameraPosition(
                      target: LatLng(35.0, 135.0), zoom: 12),
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  onStyleLoadedCallback: _onStyleLoadedCallback,
                  onUserLocationUpdated: _onUserLocationUpdated,
                ),
                Container(
                  width: 40,
                  height: 40,
                  color: Color(0xFFFFFFFF),
                  child: CupertinoButton(
                    child: Center(
                        child: Icon(
                      CupertinoIcons.checkmark,
                      color: Color(0xFF000000),
                    )),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NearbyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NearbyPageState();
}
