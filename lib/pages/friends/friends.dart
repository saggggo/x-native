import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class FriendsPageNavigationContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CupertinoSwitch(
          value: true,
          onChanged: (tf) {},
        )
      ],
    );
  }
}

class FriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Permission.location.status.then((p) {
      print(p);
    });
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: FriendsPageNavigationContents(),
        ),
        child: Center(
          child:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: []),
        ));
  }
}
