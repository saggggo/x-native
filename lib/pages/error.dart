import 'package:flutter/cupertino.dart';

class Error extends StatelessWidget {
  final String message;

  Error([this.message = "Something went wrong."]);

  @override
  Widget build(BuildContext ctx) {
    return Center(child: Text(this.message, textDirection: TextDirection.ltr));
  }
}
