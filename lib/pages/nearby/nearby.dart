import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class NearByPageNavigationContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // CupertinoSwitch(
        //   value: true,
        //   onChanged: (tf) {},
        // )
      ],
    );
  }
}

class NearByPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Permission.location.status.then((p) {
      print(p);
    });
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: NearByPageNavigationContents(),
      ),
      child: SafeArea(child: _NearByPageContents()),
    );
  }
}

class _NearByPageContents extends StatefulWidget {
  State<StatefulWidget> createState() => _NearByPageContentsState();
}

enum _Progress { initialize, waiting, connected }

class _NearByPageContentsState extends State<_NearByPageContents>
    with SingleTickerProviderStateMixin {
  _Progress progress = _Progress.initialize;

  final DecorationTween decorationTween = DecorationTween(
    begin: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      border: Border.all(width: 0),
      borderRadius: BorderRadius.circular(100.0),
    ),
    end: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      border: Border.all(width: 30, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(100.0),
      // No shadow.
    ),
  );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat(reverse: true);

  @override
  Widget build(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: DecoratedBoxTransition(
              decoration: decorationTween.animate(_controller),
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xFF222222),
            borderRadius: BorderRadius.circular(10),
          ),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("接続タイプ", style: TextStyle(color: Color(0xFFFFFFFF))),
                  Text("近くの人 >", style: TextStyle(color: Color(0xFFbbbbbb)))
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (progress != _Progress.initialize)
                GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Color(0xFF666666),
                      border: Border.all(color: Color(0xFF222222), width: 3),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Center(child: Text("接続")),
                  ),
                ),
              GestureDetector(
                onTap: () async {
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);

                  setState(() {
                    if (progress == _Progress.initialize) {
                      progress = _Progress.waiting;
                    } else {
                      progress = _Progress.initialize;
                    }
                  });
                },
                child: (progress == _Progress.initialize)
                    ? Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: Color(0xFF666666),
                          border:
                              Border.all(color: Color(0xFF222222), width: 3),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Center(child: Text("接続")),
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF0000),
                          border:
                              Border.all(color: Color(0xFF222222), width: 3),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Center(child: Text("切断")),
                      ),
              ),
              if (progress != _Progress.initialize)
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Color(0xFF666666),
                      border: Border.all(color: Color(0xFF222222), width: 3),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Center(child: Text("ミュート")),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
