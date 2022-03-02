import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shiga_native/api/firestore.dart';
import '../../components/loading.dart';

class QRWidget extends StatelessWidget {
  final String qrstring;

  QRWidget(this.qrstring);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Color(0x11FFFFFF)),
        padding: EdgeInsets.all(25),
        child: Column(children: [
          QrImage(
              data: qrstring,
              version: QrVersions.auto,
              size: 200,
              foregroundColor: Theme.of(context).canvasColor),
          Text("ID: " + qrstring)
        ]));
  }
}

// class UserAddPageNavigationContents extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [Text("useradd")],
//     );
//   }
// }

class UserAddPage extends StatefulWidget {
  @override
  State<UserAddPage> createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  String searchId = "";
  bool tabLeft = true;
  bool isQRScanMode = false;

  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller.pauseCamera();
    // } else if (Platform.isIOS) {
    controller?.resumeCamera();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // navigationBar: CupertinoNavigationBar(middle: Text("友達を追加")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                        child: Text(
                          "QRで追加",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: tabLeft
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).unselectedWidgetColor,
                          ),
                        ),
                        onPressed: !tabLeft
                            ? () {
                                setState(() {
                                  tabLeft = !tabLeft;
                                });
                              }
                            : null),
                    MaterialButton(
                        child: Text(
                          "IDで追加",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !tabLeft
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).unselectedWidgetColor,
                          ),
                        ),
                        onPressed: tabLeft
                            ? () {
                                setState(() {
                                  tabLeft = !tabLeft;
                                });
                              }
                            : null)
                  ],
                ),
              ),
              if (tabLeft)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (isQRScanMode)
                        Container(
                          width: 200,
                          height: 200,
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                          ),
                        )
                      else
                        QRWidget("xxfffdafd"),
                      OutlinedButton(
                          child: Icon(
                            Ionicons.camera_sharp,
                            size: 50,
                            color: Color(0xFFFFFFFF),
                          ),
                          style: OutlinedButton.styleFrom(
                              fixedSize: Size(80, 80),
                              shape: CircleBorder(),
                              backgroundColor: Color(0xFF666666)),
                          onPressed: () async {
                            var p = await Permission.camera.request();
                            print(p);
                            if (p.isGranted) {
                              setState(() {
                                isQRScanMode = !isQRScanMode;
                              });
                            } else if (p.isPermanentlyDenied) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                        // title: Text(),
                                        content:
                                            Text("設定画面にてカメラのアクセスを許可してください"),
                                        actions: <Widget>[
                                          MaterialButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              openAppSettings();
                                              return Navigator.of(ctx).pop();
                                            },
                                            // isDefaultAction: true,
                                          )
                                        ]);
                                  });
                            }
                          }),
                    ],
                  ),
                )
              else
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                        child: TextField(
                          // placeholder: 'IDを入力',
                          onSubmitted: (text) {
                            print(text);
                            setState(() {
                              searchId = text;
                            });
                          },
                        ),
                      ),
                      if (searchId != "")
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("profile")
                              .doc(searchId)
                              .get(),
                          builder: (BuildContext ctx,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text("エラーが発生しました。しばらく経ってからやり直してください。",
                                  style: TextStyle(color: Color(0xFFFFFFFF)));
                            } else if (snapshot.hasData &&
                                !snapshot.data!.exists) {
                              return Text("ユーザーが存在しません",
                                  style: TextStyle(color: Color(0xFFFFFFFF)));
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Loading();
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              FireUserProfile profile = FireUserProfile.from(
                                  snapshot.data?.data()
                                      as Map<String, dynamic>);
                              return Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: profile.photoURL != null
                                          ? Image.network(profile.photoURL!)
                                          : Icon(Icons.album),
                                      title: Text(profile.displayName),
                                      subtitle: Text("自己紹介"),
                                      trailing:
                                          Icon(Ionicons.person_add_outline),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Loading();
                            }
                          },
                        )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _showAddUserDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Text("hoge"),
          );
        });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
