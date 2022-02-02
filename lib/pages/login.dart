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
    return CupertinoApp(
      home: Container(
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
                '',
                style: TextStyle(
                    fontFamily: 'RockSalt', fontSize: 70, color: Colors.white),
              )),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: CupertinoButton(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    color: Color(0xFF4285F4),
                    child: Container(
                      height: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/img/btn_google_signin_dark_normal.png",
                            fit: BoxFit.fitHeight,
                            filterQuality: FilterQuality.high,
                          ),
                          Expanded(
                            child: Text(
                              "Sign in with Google",
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF), fontSize: 22),
                            ),
                          )
                        ],
                      ),
                    ),
                    onPressed: () {
                      loadingCallback(true);
                      signInWithGoogle().whenComplete(() {
                        loadingCallback(false);
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
