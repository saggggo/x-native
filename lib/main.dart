import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'pages/entry.dart';
import 'pages/login.dart';
import 'pages/error.dart';
import 'api/firestore.dart';
import 'components/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FirebaseHandler());
}

class FirebaseHandler extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Error(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return LoginHandler();
        }

        return Loading();
      },
    );
  }
}

class LoginHandler extends StatefulWidget {
  @override
  State<LoginHandler> createState() => _LoginHandlerState();
}

class _LoginHandlerState extends State<LoginHandler> {
  User? fireAuthUser;
  bool loading = true;

  _LoginHandlerState() : super() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      // FirebaseAuth.instance.signOut();
      setLoading(false);
      setFireUser(user);
    });
  }
  void setFireUser(User? user) {
    setState(() {
      fireAuthUser = user;
    });
  }

  void setLoading(bool tf) {
    setState(() {
      loading = tf;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    if (loading) {
      return Loading();
    }

    if (fireAuthUser != null) {
      return UserInformation(fireAuthUser!);
    } else {
      return Login(
        loadingCallback: setLoading,
      );
    }
  }
}

class UserInformation extends StatefulWidget {
  final User user;

  UserInformation(this.user);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  Stream<DocumentSnapshot<Object?>>? stream;
  @override
  void initState() {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(widget.user.uid);

    setState(() {
      stream = userRef.snapshots();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: stream!,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Error(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        if (snapshot.data == null) {
          print('snapshot.data is null');
          return Error('snapshot.data is null');
        }
        Map<String, dynamic>? snapshotData =
            snapshot.data?.data() as Map<String, dynamic>?;
        if (snapshotData == null) {
          print('snapshot.data.data is null');
          return Error('snapshot.data.data is null');
        }
        FireUser? fireuser = FireUser.from(snapshotData);
        return Provider(create: (_) => fireuser, child: Entry());
      },
    );
  }
}
