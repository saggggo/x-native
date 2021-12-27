import 'dart:developer';
import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../components/loading.dart';
import 'package:geohashlib/geohashlib.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Init firestore and geoFlutterFire

class Spot {
  final GeoHash geohash;
  final Latitude lat;
  final Longitude lon;
  final Timestamp timestamp;

  Spot(this.geohash, this.lat, this.lon, this.timestamp);
  static Spot fromMap(Map<String, dynamic> obj) {
    return new Spot(obj["geohash"], obj["lat"], obj["lng"], obj["timestamp"]);
  }
}

final _firestore = FirebaseFirestore.instance;

typedef SymbolId = String;

class _NearbyPageState extends State<NearbyPage> {
  bool tf = false;
  bool current = false;
  bool loop = true;
  bool didMapCreated = false;
  bool didStyleLoaded = false;
  UserLocation? lastLocation;
  late MapboxMapController mController;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;
  Circle? userCircle;
  List<Marker> _markers = [];
  List<_MarkerState> _markerStates = [];

  void _renderer() {
    if (loop) {
      mController
          .getMetersPerPixelAtLatitude(this.lastLocation!.position.latitude)
          .then((unit) {
        return mController.updateCircle(
            userCircle!, CircleOptions(circleRadius: 1000 / unit));
      }).whenComplete(() {
        new Timer(new Duration(milliseconds: 10), () {
          this._renderer();
        });
      });
    }
  }

  void _addMarker(String key, Point<double> point, LatLng coordinate) {
    setState(() {
      _markers.add(Marker(key, point, coordinate, this._addMarkerStates));
    });
  }

  void _addMarkerStates(_MarkerState markerState) {
    _markerStates.add(markerState);
  }

  void _updateMarkerPosition() {
    final coordinates = <LatLng>[];

    for (var i = 0; i < this._markerStates.length; i++) {
      coordinates.add(this._markers[i].coordinate);
    }

    this.mController.toScreenLocationBatch(coordinates).then((points) {
      this._markerStates.asMap().forEach((i, value) {
        this._markerStates[i].updatePosition(points[i]);
      });
    });
  }

  void _onMapCreated(MapboxMapController mc) async {
    print("map is created");
    mController = mc;
    // mController.onSymbolTapped.add((Symbol sym) {
    //   print("symbol tapped: " + sym.id);
    // });
    mController.addListener(() {
      if (mController.isCameraMoving) {
        _updateMarkerPosition();
      }
    });
    setState(() {
      _myLocationTrackingMode = MyLocationTrackingMode.Tracking;
    });
    final ByteData bytes =
        await rootBundle.load("assets/img/location-outline.png");
    final Uint8List imagebinary = bytes.buffer.asUint8List();
    await mController.addImage("spot", imagebinary);
    if (didStyleLoaded) {
      _renderer();
    }
    didMapCreated = true;
  }

  void _onStyleLoadedCallback() {
    print("map style loaded");
    if (didMapCreated) {
      _renderer();
    }
    didStyleLoaded = true;
  }

  void _onMapClick(Point<double> p, LatLng lg) {
    print("map clicked: " + p.toString() + "," + lg.toString());
  }

  void _onUserLocationUpdated(UserLocation location) {
    lastLocation = location;
    print(distanceBetween(
        geoPointForDouble(
            lastLocation!.position.latitude, lastLocation!.position.longitude),
        geoPointForDouble(
            location.position.latitude, location.position.longitude)));
    if (location.horizontalAccuracy != null &&
        100 > location.horizontalAccuracy!) {
      lastLocation = location;
    }

    if (location.heading?.trueHeading != null) {
      mController
          .moveCamera(CameraUpdate.bearingTo(location.heading!.trueHeading!));
    }
    if (userCircle != null) {
      mController.updateCircle(
        userCircle!,
        CircleOptions(geometry: location.position),
      );
    } else {
      mController
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
    _updateMarkerPosition();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      child: SafeArea(
        top: false,
        child: Center(
          child: Container(
            color: Color(0xFFFFFFFF),
            child: Stack(
              // alignment: const Alignment(0, 0.9),
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
                IgnorePointer(
                    ignoring: true,
                    child: Stack(
                      children: _markers,
                    )),
                SafeArea(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: deviceWidth * .8,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          border: Border.all(color: Color(0xFFEEEEEE)),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF333333),
                              offset: Offset(3, 3),
                              blurRadius: 3.0,
                              spreadRadius: 1.0,
                            ),
                          ]),
                      child: CupertinoButton(
                          child: Align(
                            child: Icon(
                              CupertinoIcons.checkmark,
                              color: Color(0xFF000000),
                            ),
                          ),
                          onPressed: () {
                            var areas = geohashQueryBounds(
                                geoPointForDouble(
                                    lastLocation!.position.latitude,
                                    lastLocation!.position.longitude),
                                500);
                            Future.forEach<Map<String, String>>(areas, (area) {
                              return _firestore
                                  .collection("spots")
                                  .orderBy('geohash')
                                  .startAt([area["start"]])
                                  .endAt([area["end"]])
                                  .get()
                                  .then((res) {
                                    List<Spot> spots = [];
                                    for (var doc in res.docs) {
                                      var sp = Spot.fromMap(doc.data());
                                      var dist = distanceBetween(
                                          geoPointForDouble(sp.lat, sp.lon),
                                          geoPointForDouble(
                                              lastLocation!.position.latitude,
                                              lastLocation!
                                                  .position.longitude));
                                      print(dist);
                                      if (500 > dist) {
                                        spots.add(sp);
                                      }
                                    }
                                    mController
                                        .toScreenLocationBatch(spots.map(
                                            (elm) => LatLng(elm.lat, elm.lon)))
                                        .then((value) {
                                      for (var i = 0; i < value.length; i++) {
                                        Point<double> p = Point<double>(
                                            value[i].x as double,
                                            value[i].y as double);
                                        _addMarker(spots[i].geohash, p,
                                            LatLng(spots[i].lat, spots[i].lon));
                                      }
                                    });
                                  });
                            });
                          }),
                    ),
                  ),
                ),
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

class Marker extends StatefulWidget {
  final Point initialPosition;
  final LatLng coordinate;
  final void Function(_MarkerState) _addMarkerState;

  Marker(
      String key, this.initialPosition, this.coordinate, this._addMarkerState)
      : super(key: Key(key));

  State<StatefulWidget> createState() {
    final s = _MarkerState(this.initialPosition);
    _addMarkerState(s);
    return s;
  }
}

class _MarkerState extends State {
  final _iconSize = 50.0;
  Point<num> position;

  _MarkerState(this.position);

  updatePosition(Point<num> point) {
    setState(() {
      this.position = point;
    });
  }

  Widget build(BuildContext ctx) {
    var ratio = Platform.isIOS ? 1.0 : MediaQuery.of(ctx).devicePixelRatio;
    return Positioned(
      left: position.x / ratio - _iconSize / 2,
      top: position.y / ratio - _iconSize / 2,
      child: Image.asset(
        'assets/img/location-outline.png',
        height: _iconSize,
      ),
    );
  }
}
