import 'package:flutter/cupertino.dart';

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
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: FriendsPageNavigationContents(),
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CupertinoButton(
              child: Text('Press!!'),
              onPressed: () async {},
            ),
            CupertinoButton(
              child: Text('Test'),
              onPressed: () {},
            ),
          ]),
        ));
  }
}
