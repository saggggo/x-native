import 'package:flutter/cupertino.dart';
import 'nearby/routes.dart';
import 'home/routes.dart';
import 'profile/routes.dart';
import 'location/routes.dart';
import 'fullscreen/shiga_waiting.dart';
import 'package:ionicons/ionicons.dart';
import 'error.dart';
import "./testpage.dart";

class Entry extends StatelessWidget {
  @override
  build(BuildContext ctx) {
    return CupertinoApp(
      theme: CupertinoThemeData(
          brightness: Brightness.dark, primaryColor: Color(0xFFFFFFFF)),
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
  final CupertinoTabController _tabController = CupertinoTabController();
  int? from;

  Frame() {
    // _tabController.addListener(() {
    // int to = _tabController.index;
    // micボタンが押された場合
    // if (to == 2) {
    //   if (this.from != null) {
    //     _tabController.index = this.from!;
    //   } else {
    //     _tabController.index = 0;
    //   }
    // } else {
    //   this.from = to;
    // }
    // });
  }

  Widget build(BuildContext ctx) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: "ホーム", icon: Icon(Ionicons.home_outline, size: 24)),
          BottomNavigationBarItem(
              label: "近く",
              icon: Icon(Ionicons.navigate_circle_outline, size: 24)),
          // BottomNavigationBarItem(
          //     label: "録音", icon: Icon(Ionicons.mic_outline, size: 24)),
          BottomNavigationBarItem(
              label: "マップ", icon: Icon(Ionicons.location_outline, size: 24)),
          BottomNavigationBarItem(
              label: "プロフィール", icon: Icon(Ionicons.id_card_outline, size: 24))
        ],
        iconSize: 25,
        currentIndex: 2,
      ),
      controller: _tabController,
      tabBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return HomeRoutes();
          // return TestPage();
        } else if (index == 1) {
          return NearByRoutes();
        } else if (index == 2) {
          return LocationRoutes();
        } else if (index == 3) {
          return ProfileRoutes();
        } else {
          return Error("error, unintended page");
        }
      },
    );
  }
}
