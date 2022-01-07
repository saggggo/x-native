import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../utils/types.dart';

Widget _SafeAreaWrap({required Widget child, required bool wrap}) {
  return (wrap) ? SafeArea(child: child) : child;
}

class SlidingUp extends StatefulWidget {
  final Spot spot;

  SlidingUp({Key? key, required this.spot}) : super(key: key);

  State<StatefulWidget> createState() => SlidingUpState();
}

class SlidingUpState extends State<SlidingUp> {
  bool isPanelOpened = false;
  PanelController controller = PanelController();

  SlidingUpState();

  void halfOpen() {
    controller.panelPosition = 0.1;
  }

  @override
  void initState() {
    super.initState();
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => halfOpen()); // build の後に呼び出される
    }
  }

  @override
  Widget build(BuildContext ctx) {
    Spot spot = widget.spot;
    return SlidingUpPanel(
      color: Color(0xFF000000),
      defaultPanelState: PanelState.CLOSED,
      backdropEnabled: true,
      backdropTapClosesPanel: true,
      maxHeight: MediaQuery.of(context).size.height,
      snapPoint: 0.3,
      minHeight: 0,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      controller: controller,
      onPanelSlide: (double position) {
        print(isPanelOpened);
        print(position);
        if (position > 0.8) {
          setState(() {
            isPanelOpened = true;
          });
        } else {
          setState(() {
            isPanelOpened = false;
          });
        }
      },
      panel: Column(
        children: [
          if (!isPanelOpened)
            Container(
              height: 20,
              child: Center(
                child: Container(
                  width: 200,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xFFBBBBBB),
                  ),
                ),
              ),
            ),
          _SafeAreaWrap(
            wrap: isPanelOpened,
            child: Container(
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 10),
                    child: Text(
                      spot.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFFFFFFFF)),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  "トーク",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFFFFFFFF)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 30),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/voiceChat/create');
                                  },
                                  child: Text(
                                    "新しく開始",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...spot.voiceChat.map(
                                (sp) => Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: Column(children: [
                                    UserIconCircle(
                                      child: Text(
                                        "hoge",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "お話ししませんか",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Column(children: [
                                  UserIconCircle(
                                    child: Text(
                                      "hoge",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "お話ししませんか",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Column(children: [
                                  UserIconCircle(
                                    child: Text(
                                      "hoge",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "最近引っ越して...",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Column(children: [
                                  UserIconCircle(
                                    child: Text(
                                      "hoge",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "こんにちは",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Column(children: [
                                  UserIconCircle(
                                    child: Text(
                                      "hoge",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "周辺のご飯屋さん",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    UserIconCircle(
                                      child: Text(
                                        "hoge",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "もっと見る",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFEEEEEE)),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  "掲示板",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFFFFFFFF)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 30),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "新しく開始",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 30,
                          child: Row(
                            children: [
                              Text("周辺のご飯屋さん情報",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFFFFFFFF))),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 30,
                          child: Row(
                            children: [
                              Text("周辺のご飯屋さん情報",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFFFFFFFF))),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 30,
                          child: Row(
                            children: [
                              Text(
                                "周辺のご飯屋さん情報",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFFFFFFFF)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UserIconCircle extends StatelessWidget {
  Widget? child;
  final double size;
  final EdgeInsets? margin;
  UserIconCircle(
      {this.child,
      this.size = 60,
      this.margin = const EdgeInsets.fromLTRB(5, 0, 5, 0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      margin: margin,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Center(child: this.child),
    );
  }
}
