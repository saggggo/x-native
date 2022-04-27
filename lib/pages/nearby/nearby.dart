import 'dart:async';
import "dart:math";
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shiga_native/components/animation/ripples_animation.dart';

class NearByPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Permission.location.status.then((p) {
      print(p);
    });
    return SafeArea(child: _NearByPageContents());
  }
}

class _NearByPageContents extends StatefulWidget {
  State<StatefulWidget> createState() => _NearByPageContentsState();
}

// class SequentialAnimationController extends AnimationController {
//   SequentialAnimationController({
//     required int steps,
//     double? value,
//     Duration? duration,
//     Duration? reverseDuration,
//     String? debugLabel,
//     double lowerBound = 0.0,
//     double upperBound = 1.0,
//     AnimationBehavior animationBehavior = AnimationBehavior.normal,
//     required TickerProvider vsync,
//   }) : super(
//             value: value,
//             duration: duration,
//             reverseDuration: reverseDuration,
//             debugLabel: debugLabel,
//             lowerBound: lowerBound,
//             animationBehavior: animationBehavior,
//             vsync: vsync) {
//     if (steps > 10 || 0 > steps) {
//       throw new Exception();
//     }
//     this.steps = steps - 1;
//   }
//   late int steps;
//   int _step = 0;

//   int get step => _step;

//   TickerFuture repeat(
//       {double? min, double? max, bool reverse = false, Duration? period}) {
//     super.addStatusListener((status) {
//       if (AnimationStatus.completed == status) {
//         if (this.steps == this.step) {
//           super.repeat();
//         } else if (this.steps > this.step) {
//           this._step++;
//           super.reset();
//           super.repeat();
//         }
//       }
//     });
//     return super.repeat(min: min, max: max, reverse: reverse, period: period);
//   }

//   void next() {
//     if (steps > step) {
//       super.reset();
//       _step++;
//     }
//   }

//   void before() {
//     if (_step > 0) {
//       super.reset();
//       _step--;
//     }
//   }

//   void reset() {
//     super.reset();
//     _step = 0;
//   }
// }

enum _Progress { initialize, waiting, connected }

class _NearByPageContentsState extends State<_NearByPageContents> {
  GlobalKey<RippplesAnimationState> key = GlobalKey();

  @override
  void initState() {
    print("initState");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  _Progress progress = _Progress.initialize;

  @override
  Widget build(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: RipplesAnimation(key: key),
            ),
            // Center(
            //   child: Container(
            //     height: 120,
            //     width: 120,
            //     decoration: BoxDecoration(
            //       color: Color(0xFFFFFFFF),
            //       borderRadius: BorderRadius.circular(100),
            //     ),
            //   ),
            // ),
          ]),
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
                    child: Center(child: Text("スピーカー")),
                  ),
                ),
              GestureDetector(
                onTap: () async {
                  print(progress);

                  setState(() {
                    if (progress == _Progress.initialize) {
                      progress = _Progress.waiting;
                      key.currentState!.forward();
                    } else {
                      progress = _Progress.initialize;
                      key.currentState!.stop();
                      key.currentState!.reset();
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
