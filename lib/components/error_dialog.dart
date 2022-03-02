import 'package:flutter/material.dart';

Future errorDialog(BuildContext context, String title, String message) {
  return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              MaterialButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(ctx).pop(),
                // isDefaultAction: true,
              )
            ]);
      });
}

Future networkError(BuildContext context, String message) {
  return errorDialog(context, "ネットワークエラー", message);
}

Future locationError(BuildContext context, String message) {
  return errorDialog(context, "位置情報エラー", message);
}

Future permissionError(BuildContext context, String message) {
  return errorDialog(context, "パーミッションエラー", message);
}
