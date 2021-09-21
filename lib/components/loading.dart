import 'package:flutter/cupertino.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Center(
        child: CupertinoActivityIndicator(
      radius: 15,
    ));
  }
}
