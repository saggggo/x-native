import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../api/firestore.dart';
import '../../components/loading.dart';

class ProfilePageNavigationContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CupertinoButton(
          child: Icon(CupertinoIcons.scribble),
          onPressed: () {
            Navigator.pushNamed(context, '/editing');
          },
        ),
        CupertinoButton(
          child: Icon(CupertinoIcons.gear),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final CollectionReference profileRef =
      FirebaseFirestore.instance.collection('profile');

  bool editing = false;

  @override
  Widget build(BuildContext context) {
    print("profile screen");
    var user = context.read<FireUser>();
    var profilePromise = profileRef.doc(user.uid).get();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: ProfilePageNavigationContents(),
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

              return Column(
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
                                  child: Text(
                                    profile.displayName ?? "",
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
                                Text(profile.gender ?? ""),
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
                                  child: Text(profile.city ?? ""),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("言語"),
                                Text(profile.language ?? ""),
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
                                  child: Text(profile.introduce ?? ""),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }

            return Loading();
          },
        ),
      ),
    );
  }
}
