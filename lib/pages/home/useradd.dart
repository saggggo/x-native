import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';
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
              foregroundColor: Color(0xFFFFFFFF)),
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("友達を追加")),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          // QRWidget("qrstring"),
          Container(
            padding: EdgeInsets.fromLTRB(30, 110, 30, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                    child: Text(
                      "QRで追加",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(tabLeft ? 0xFFFFFFFF : 0xFF999999)),
                    ),
                    onPressed: !tabLeft
                        ? () {
                            setState(() {
                              tabLeft = !tabLeft;
                            });
                          }
                        : null),
                CupertinoButton(
                    child: Text(
                      "IDで追加",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(!tabLeft ? 0xFFFFFFFF : 0xFF999999),
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
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            // if (tabLeft)
            //   Center(
            //     child: Container(
            //       height: 250,
            //       width: 250,
            //       child: QRView(
            //         key: qrKey,
            //         onQRViewCreated: _onQRViewCreated,
            //       ),
            //     ),
            //   ),
            if (tabLeft) QRWidget("xxfffdafd"),
            if (tabLeft)
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: Color(0xFF999999),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Ionicons.camera_sharp,
                  size: 50,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            if (!tabLeft)
              Container(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                child: CupertinoTextField(
                  placeholder: 'IDを入力',
                  onSubmitted: (text) {
                    print(text);
                    setState(() {
                      searchId = text;
                    });
                  },
                ),
              ),
            if (!tabLeft && searchId != "")
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
                  } else if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("ユーザーが存在しません",
                        style: TextStyle(color: Color(0xFFFFFFFF)));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Loading();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    FireUserProfile profile = FireUserProfile.from(
                        snapshot.data?.data() as Map<String, dynamic>);
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: profile.photoURL != null
                                ? Image.network(profile.photoURL!)
                                : Icon(Icons.album),
                            title: Text(profile.displayName),
                            subtitle: Text("自己紹介"),
                            trailing: Icon(Ionicons.person_add_outline),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Loading();
                  }
                },
              )
          ])
        ]),
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
    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
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
