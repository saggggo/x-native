import 'dart:developer';
import 'dart:ffi';
import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geohashlib/geohashlib.dart';
import '../../api/firestore.dart';
import './_sliding_up.dart';

GeoPoint latLng2GeoPoint(LatLng latlng) {
  return GeoPoint(latlng.latitude, latlng.longitude);
}

class _LocationPageState extends State<LocationPage> {
  final GlobalKey<SlidingUpState> _slidingUpStateKey = GlobalKey();

  bool tf = false;
  bool current = false;
  bool loop = true;
  bool didMapCreated = false;
  bool didStyleLoaded = false;
  UserLocation? userLocation;
  UserLocation? lastSpotLocation;
  // PanelController pController = PanelController();
  Spot? spotFocused;
  late MapboxMapController mController;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;
  Circle? userCircle;
  List<Marker> _markers = [];
  List<_MarkerState> _markerStates = [];

  void spotUpdate() {
    if (userLocation != null &&
        (lastSpotLocation == null ||
            distanceBetween(latLng2GeoPoint(userLocation!.position),
                    latLng2GeoPoint(lastSpotLocation!.position)) >
                100)) {
      lastSpotLocation = userLocation;
      print("spotUpdate");
      var areas = geohashQueryBounds(
          geoPointForDouble(userLocation!.position.latitude,
              userLocation!.position.longitude),
          500);
      Future.forEach<Map<String, String>>(areas, (area) {
        return Spot.search(area["start"]!, area["end"]!).then((spots) {
          var filtered = spots.where((sp) {
            print(sp);
            var dist = distanceBetween(
                geoPointForDouble(sp.lat, sp.lon),
                geoPointForDouble(userLocation!.position.latitude,
                    userLocation!.position.longitude));
            return 500 > dist;
          }).toList();
          mController
              .toScreenLocationBatch(
                  filtered.map((elm) => LatLng(elm.lat, elm.lon)))
              .then((value) {
            for (var i = 0; i < value.length; i++) {
              Point<double> p =
                  Point<double>(value[i].x as double, value[i].y as double);
              _addMarker(filtered[i], p);
            }
          });
        });
      });
    }
  }

  void _renderer() {
    if (loop) {
      mController
          .getMetersPerPixelAtLatitude(this.userLocation!.position.latitude)
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

  void _addMarker(Spot sp, Point<double> point) {
    for (var i = 0; i < _markers.length; i++) {
      if (_markers[i].key == Key(sp.geohash)) {
        return;
      }
    }
    setState(() {
      _markers
          .add(Marker(sp, point, this._addMarkerStates, this._onMarkerTapped));
    });
  }

  void _addMarkerStates(_MarkerState markerState) {
    _markerStates.add(markerState);
  }

  void _onMarkerTapped(Spot sp) {
    print("_onMarkerTapped: " + sp.name);
    setState(() {
      this.spotFocused = sp;
      if (this._slidingUpStateKey.currentState != null) {
        this._slidingUpStateKey.currentState!.halfOpen();
      }
    });
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
    setState(() {
      spotFocused = null;
    });
  }

  void _onUserLocationUpdated(UserLocation location) {
    // print(distanceBetween(geoPointForDouble(userLocation!.position.latitude, userLocation!.position.longitude), geoPointForDouble(location.position.latitude, location.position.longitude)));
    spotUpdate();
    if (location.horizontalAccuracy != null &&
        100 > location.horizontalAccuracy!) {
      userLocation = location;
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

    return Scaffold(
      body: SafeArea(
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
                  accessToken: "",
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
                Stack(
                  children: _markers,
                ),
                SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
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
                            child: MaterialButton(
                                child: Align(
                                  child: Icon(
                                    Icons.check,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                onPressed: () {
                                  spotUpdate();
                                }),
                          ),
                        ),
                      ]),
                ),
                if (spotFocused != null)
                  SlidingUp(key: _slidingUpStateKey, spot: this.spotFocused!)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LocationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LocationPageState();
}

class Marker extends StatefulWidget {
  final Spot spot;
  final Point initialPosition;
  final void Function(Spot) tapHandler;
  final void Function(_MarkerState) _addMarkerState;

  Marker(this.spot, this.initialPosition, this._addMarkerState, this.tapHandler)
      : super(key: Key(spot.geohash));

  LatLng get coordinate => LatLng(this.spot.lat, this.spot.lon);

  State<StatefulWidget> createState() {
    final s = _MarkerState(this.initialPosition, () {
      this.tapHandler(this.spot);
    });
    _addMarkerState(s);
    return s;
  }
}

class _MarkerState extends State {
  final _iconSize = 40.0;
  void Function() tapHandler;
  Point<num> position;

  _MarkerState(this.position, this.tapHandler);

  updatePosition(Point<num> point) {
    setState(() {
      this.position = point;
    });
  }

  Widget build(BuildContext ctx) {
    var ratio = Platform.isIOS ? 1.0 : MediaQuery.of(ctx).devicePixelRatio;
    var left = position.x / ratio - _iconSize / 2;
    var top = position.y / ratio - _iconSize;
    // var left = position.x / ratio;
    // var top = position.y / ratio;
    return Positioned(
        left: left,
        top: top,
        child: Container(
          child: GestureDetector(
              onTap: () {
                this.tapHandler();
              },
              child: Image.asset(
                'assets/img/location-outline.png',
                width: _iconSize,
                height: _iconSize,
              )),
        ));
  }
}
