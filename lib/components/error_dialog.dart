import 'package:flutter/cupertino.dart';

Future errorDialog(BuildContext context, String title, String message) {
  return showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("OK"),
                onPressed: () => Navigator.of(ctx).pop(),
                isDefaultAction: true,
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
