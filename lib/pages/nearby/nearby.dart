import 'dart:math';

import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../components/loading.dart';

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
  bool current = false;
  bool loop = true;
  UserLocation? lastLocation;
  MapboxMapController? mController;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;
  Circle? userCircle;

  void renderer() {
    if (mController != null && loop) {
      mController!
          .getMetersPerPixelAtLatitude(this.lastLocation!.position.latitude)
          .then((unit) {
        return mController!.updateCircle(
            userCircle!, CircleOptions(circleRadius: 1000 / unit));
      }).whenComplete(() {
        new Timer(new Duration(milliseconds: 10), () {
          this.renderer();
        });
      });
    }
  }

  void _onMapCreated(MapboxMapController mc) {
    print("map is created");
    mController = mc;
    this.renderer();
    setState(() {
      _myLocationTrackingMode = MyLocationTrackingMode.Tracking;
    });
  }

  void _onMapClick(Point<double> p, LatLng lg) {
    print("map clicked: " + p.toString() + "," + lg.toString());
  }

  void _onStyleLoadedCallback() {
    print("map style loaded");
  }

  void _onUserLocationUpdated(UserLocation location) {
    lastLocation = location;

    if (mController != null && location.heading?.trueHeading != null) {
      mController!
          .moveCamera(CameraUpdate.bearingTo(location.heading!.trueHeading!));
    }
    if (userCircle != null) {
      mController!.updateCircle(
        userCircle!,
        CircleOptions(geometry: location.position),
      );
    } else {
      mController!
          .addCircle(
            CircleOptions(
                geometry: location.position,
                circleOpacity: 0.5,
                circleRadius: 60,
                circleColor: "#FF0000"),
          )
          .then(
            (circle) => {
              setState(() {
                userCircle = circle;
              })
            },
          );
    }
  }

  void _onCameraTrackingChanged(MyLocationTrackingMode mode) {
    print(mode.toString());
  }

  void _onCameraTrackingDismissed() {
    print("dismissed");
    this.setState(() {
      _myLocationTrackingMode = MyLocationTrackingMode.None;
    });
  }

  void _onCameraIdle() {
    print("camera idle");
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
              alignment: const Alignment(0.9, 0.9),
              children: [
                MapboxMap(
                  // styleString: MapboxStyles.DARK,
                  styleString:
                      "mapbox://styles/saggggo/ckwrw7sfv2djb14o6gubjx42t",
                  initialCameraPosition: const CameraPosition(
                      target: LatLng(35.0, 135.0), zoom: 12, tilt: 15),
                  myLocationEnabled: true,
                  myLocationTrackingMode: _myLocationTrackingMode,
                  // trackCameraPosition: true,
                  accessToken:
                      "***REMOVED***",
                  onMapCreated: _onMapCreated,
                  onMapClick: _onMapClick,
                  onStyleLoadedCallback: _onStyleLoadedCallback,
                  onUserLocationUpdated: _onUserLocationUpdated,
                  onCameraTrackingChanged: _onCameraTrackingChanged,
                  onCameraTrackingDismissed:
                      _onCameraTrackingDismissed, // カメラのトラッキングが解除された際のイベント
                  onCameraIdle: _onCameraIdle, // カメラが停止した際のイベント
                  rotateGesturesEnabled: false, // 地図の回転
                  scrollGesturesEnabled: false, // 地図の移動
                  tiltGesturesEnabled: false, // 地図の傾き
                  zoomGesturesEnabled: true, // 地図の拡大
                  compassEnabled: false,
                  minMaxZoomPreference: MinMaxZoomPreference(12, 17),
                  attributionButtonPosition:
                      AttributionButtonPosition.BottomLeft,
                  attributionButtonMargins: Point(-50, -50), // 画面外
                  logoViewMargins: Point(-50, -50), // 画面外
                ),
                Container(
                  width: 40,
                  height: 40,
                  color: Color(0xFFFFFFFF),
                  child: CupertinoButton(
                    child: Align(
                      child: Icon(
                        CupertinoIcons.checkmark,
                        color: Color(0xFF000000),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _myLocationTrackingMode =
                            MyLocationTrackingMode.Tracking;
                      });
                    },
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
