import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../api/firestore.dart';
import '../../components/loading.dart';
import "../../utils/types.dart";

final _firestore = FirebaseFirestore.instance;

Timestamp now() {
  var _now = DateTime.now().microsecondsSinceEpoch;
  return Timestamp((_now / 1000000).floor(), _now % 1000000 * 1000);
}

class CreateVoiceChatForm extends StatefulWidget {
  const CreateVoiceChatForm({Key? key}) : super(key: key);

  @override
  _CreateVoiceChatFormState createState() {
    return _CreateVoiceChatFormState();
  }
}

class _CreateVoiceChatFormState extends State<CreateVoiceChatForm> {
  final _formKey = GlobalKey<FormState>();
  double sliderValue = 4;
  String? title;
  bool titleError = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var user = context.read<FireUser>();
    final spot = ModalRoute.of(context)!.settings.arguments as Spot;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("キャンセル")),
        // middle: Text("chat"),
      ),
      child: SafeArea(
        child: (loading)
            ? Loading()
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 30),
                            child: Text("チャットを作成",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: CupertinoTextFormFieldRow(
                              onFieldSubmitted: (value) {
                                setState(() {
                                  title = value;
                                });
                              },
                              maxLength: 20,
                              decoration: BoxDecoration(
                                  color: Color(0xFF222222),
                                  borderRadius: BorderRadius.circular(5)),
                              placeholder: "タイトル",
                              validator: (str) {
                                if (str == null || str.isEmpty) {
                                  return "タイトルを指定してください";
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "最大人数",
                                  style: TextStyle(color: Color(0xFFFFFFFF)),
                                ),
                                CupertinoSlider(
                                  value: sliderValue,
                                  onChanged: (val) {
                                    print(val);
                                    setState(() {
                                      sliderValue = val;
                                    });
                                  },
                                  min: 2,
                                  max: 8,
                                  divisions: 6,
                                ),
                                Text(sliderValue.toInt().toString() + "人")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              _firestore
                                  .collection("spots")
                                  .doc(spot.geohash)
                                  .collection("voiceChat")
                                  .add({
                                "title": title,
                                "owner": user.uid,
                                "max": sliderValue,
                                "createdAt": now(),
                              }).then((value) {
                                print(value);
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text("エラー"),
                                      content:
                                          Text("不明なエラーが発生しました。再度やり直してください。"),
                                      actions: [
                                        CupertinoDialogAction(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Yes"))
                                      ],
                                    );
                                  },
                                );
                              }, onError: (err) {
                                print(err);
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text("エラー"),
                                      content:
                                          Text("不明なエラーが発生しました。再度やり直してください。"),
                                      actions: [
                                        CupertinoDialogAction(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Yes"))
                                      ],
                                    );
                                  },
                                );
                              }).whenComplete(() {
                                setState(() {
                                  loading = false;
                                });
                              });
                            }
                          },
                          child: Text("作成"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
