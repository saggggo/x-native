import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../api/firestore.dart';
import '../../api/api.dart';

class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = context.read<FireUser>();
    print("inspect user");
    inspect(user);

    return CupertinoPageScaffold(
        child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Shiga'),
      ]),
    ));
  }
}
