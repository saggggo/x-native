import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';

class HomePageNavigationContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CupertinoButton(
          child: Icon(Ionicons.person_add_outline,
              color: Color(0xff999999), size: 22),
          onPressed: () {
            Navigator.pushNamed(context, '/useradd');
          },
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: HomePageNavigationContents(),
        ),
        child: Center(
          child:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: []),
        ));
  }
}
