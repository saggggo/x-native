import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef void Callback(bool yn);

class Login extends StatelessWidget {
  final Callback loadingCallback;

  Login({required this.loadingCallback});

  @override
  Widget build(BuildContext ctx) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/background.jpeg"),
              fit: BoxFit.cover,
            ),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Center(
                  child: Text(
                'Shiga',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontFamily: 'RockSalt', fontSize: 70, color: Colors.white),
              )),
            ),
            Expanded(
                flex: 2,
                child: Center(
                    child: CupertinoButton.filled(
                        child: Text(
                          "Facebook Login",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(fontFamily: 'Sniglet', fontSize: 25),
                        ),
                        onPressed: () {
                          loadingCallback(true);
                          // signInWithFacebook().whenComplete(() {
                          //   loadingCallback(false);
                          // });
                        }))),
          ],
        ));
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

// Future<UserCredential> signInWithFacebook() {
//   // Trigger the sign-in flow
//   return FacebookAuth.instance.login().then((result) {
//     // Create a credential from the access token
//     final facebookAuthCredential =
//         FacebookAuthProvider.credential(result.token);

//     // Once signed in, return the UserCredential
//     return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//   });
// }
