import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../api/firestore.dart';
import '../../components/loading.dart';

class ProfilePageNavigationContents extends StatelessWidget {
  // final bool editing;
  // void Function(bool)? editingStateChanged;

  // ProfilePageNavigationContents(
  //     {required this.editing, this.editingStateChanged});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Icon(CupertinoIcons.checkmark),
      onPressed: () {
        // if (editingStateChanged != null) {
        //   editingStateChanged!(false);
        // }
      },
    );
  }
}

class ProfileEditingPage extends StatefulWidget {
  @override
  State<ProfileEditingPage> createState() => _ProfileEditingPageState();
}

class _ProfileEditingPageState extends State<ProfileEditingPage> {
  final CollectionReference profileRef =
      FirebaseFirestore.instance.collection('profile');

  bool editing = false;
  String? nickname;
  String? gender;
  String? city;
  String? language;
  String? introduce;

  // void setEditMode(bool tf) {
  //   setState(() {
  //     editMode = tf;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    print("profile screen");
    var user = context.read<FireUser>();
    var profilePromise = profileRef.doc(user.uid).get();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: ProfilePageNavigationContents(
            // editingStateChanged: (check) {
            //   if (!check) {
            //     if (editing) {
            //       showCupertinoModalPopup<void>(
            //         context: context,
            //         builder: (BuildContext context) => CupertinoAlertDialog(
            //           title: Text("変更を保存しますか？"),
            //           // content: Text("メッセージ"),
            //           actions: <Widget>[
            //             CupertinoDialogAction(
            //               child: Text("いいえ"),
            //               isDestructiveAction: true,
            //               onPressed: () {
            //                 Navigator.pop(context);
            //               },
            //             ),
            //             CupertinoDialogAction(
            //               child: Text("はい"),
            //               onPressed: () {
            //                 setEditMode(check);
            //                 Navigator.pop(context);
            //               },
            //             ),
            //           ],
            //         ),
            //       );
            //     } else {
            //       setEditMode(check);
            //     }
            //   } else {
            //     setEditMode(check);
            //   }
            // },
            ),
      ),
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: FutureBuilder<DocumentSnapshot>(
          future: profilePromise,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            print(snapshot.data.toString());
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              FireUserProfile profile = FireUserProfile.fromJson(data);

              return Form(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      alignment: const Alignment(.55, 0),
                      children: [
                        Image.asset(
                          "assets/img/room_plate.jpeg",
                          width: 1000,
                          fit: BoxFit.fitWidth,
                        ),
                        Image.network(
                          profile.photoURL ?? "",
                          width: 70,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text("ニックネーム"),
                                ),
                                Expanded(
                                  child: CupertinoTextField(
                                    placeholder: profile.displayName,
                                    onChanged: (value) {
                                      print(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("生年月日"),
                                Text(profile.age?.toString() ?? "2000/05/03"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("性別"),
                                CupertinoButton(
                                  padding: EdgeInsets.all(0),
                                  child: Text(profile.gender ?? ""),
                                  onPressed: () {
                                    showCupertinoModalPopup<void>(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 150,
                                          color: CupertinoColors.white,
                                          child: CupertinoPicker(
                                            children: [
                                              Text("男"),
                                              Text("女"),
                                              Text("その他"),
                                            ],
                                            itemExtent: 40,
                                            onSelectedItemChanged: (num) {},
                                          ),
                                        );
                                      },
                                      semanticsDismissible: true,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text("都市"),
                                ),
                                Expanded(
                                  child: CupertinoTextField(
                                    placeholder: profile.city,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("言語"),
                                CupertinoButton(
                                  padding: EdgeInsets.all(0),
                                  child: Text(profile.language ?? ""),
                                  onPressed: () {
                                    showCupertinoModalPopup<void>(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 150,
                                          color: CupertinoColors.white,
                                          child: SafeArea(
                                            child: CupertinoPicker(
                                              children: [
                                                Text("English"),
                                                Text("日本語"),
                                              ],
                                              itemExtent: 40,
                                              onSelectedItemChanged: (num) {},
                                            ),
                                          ),
                                        );
                                      },
                                      semanticsDismissible: true,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Text(
                                    "自己紹介",
                                    textAlign: TextAlign.start,
                                  )
                                ]),
                                Expanded(
                                  child: CupertinoTextField(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
            }

            return Loading();
          },
        ),
      ),
    );
  }
}
