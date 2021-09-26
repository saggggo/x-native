import 'package:flutter/cupertino.dart';
import 'home/home_navigator.dart';
import 'profile/profile_navigator.dart';
import 'fullscreen/shiga_waiting.dart';
import 'error.dart';

class Entry extends StatelessWidget {
  @override
  build(BuildContext ctx) {
    return CupertinoApp(
      routes: <String, WidgetBuilder>{
        "/": (BuildContext ctx) {
          return Frame();
        },
        "/waiting": (BuildContext ctx) {
          return ShigaWaitingPage();
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class Frame extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.group)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.profile_circled))
        ],
        currentIndex: 1,
      ),
      tabBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Error("unimplemented");
        } else if (index == 1) {
          return HomeNavigator();
        } else if (index == 2) {
          return ProfileNavigator();
        } else {
          return Error("error, unintended page");
        }
      },
    );
  }
}
