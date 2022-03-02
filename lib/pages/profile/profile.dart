import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';
import '../../api/firestore.dart';
import '../../components/loading.dart';

class ProfilePageNavigationContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MaterialButton(
          child:
              Icon(Ionicons.pencil_outline, size: 22, color: Color(0xff999999)),
          onPressed: () {
            Navigator.pushNamed(context, '/editing');
          },
        ),
        MaterialButton(
          child: Icon(Ionicons.settings_outline,
              size: 22, color: Color(0xff999999)),
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

    return Scaffold(
      // navigationBar: CupertinoNavigationBar(
      //   trailing: ProfilePageNavigationContents(),
      // ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: FutureBuilder<DocumentSnapshot>(
          future: profilePromise,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              FireUserProfile profile = FireUserProfile.from(data);

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
                                    profile.displayName,
                                  ),
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
