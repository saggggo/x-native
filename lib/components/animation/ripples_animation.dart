import 'package:flutter/material.dart';
import "dart:math";

class RipplesAnimationController {}

class RipplesAnimation extends StatefulWidget {
  RipplesAnimation({Key? key}) : super(key: key);

  @override
  RippplesAnimationState createState() => RippplesAnimationState();
}

class RippplesAnimationState extends State<RipplesAnimation>
    with TickerProviderStateMixin {
  RippplesAnimationState() : super() {
    controller = [
      AnimationController(vsync: this),
      AnimationController(vsync: this)
    ];
    selected = controller[step];
    selected.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // this._next();
        // selected.repeat(min: );
      }
    });
  }

  late List<AnimationController> controller;
  late AnimationController selected;
  int step = 0;

  void _next() {
    setState(() {
      step++;
      this.selected = controller[step];
    });
  }

  void _before() {
    setState(() {
      step--;
      this.selected = controller[step];
    });
  }

  TickerFuture forward() {
    return selected.forward();
  }

  TickerFuture repeat() {
    return selected.repeat();
  }

  void reset() {
    this.controller.forEach((x) {
      x.reset();
    });
    setState(() {
      step = 0;
    });
    return selected.stop();
  }

  void stop() {
    return selected.stop();
  }

  void dispose() {
    selected.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    switch (step) {
      case 0:
        return ClipRect(
            child: CustomPaint(painter: _RipplesPainter0(selected)));
      // case 1:
      //   return ClipRect(
      //       child: CustomPaint(painter: _RipplesPainter1(selected)));
      default:
        return Text("hoge");
    }
  }
}

class _RipplesPainter0 extends CustomPainter {
  _RipplesPainter0(this._animationController)
      : super(repaint: _animationController) {
    // _animationController.duration = Duration(days: 365);
    _animationController.duration = Duration(seconds: 10);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }
  AnimationController _animationController;
  late Animation<double> _animation;
  double breadth = 30;
  double offset = 60;

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width / 2;
    var height = size.height / 2;
    var diagonal = sqrt(width * width + height * height);
    var c = Offset(width, height);
    var paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    var maxradius = TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(begin: offset, end: diagonal),
            weight: 100 * (diagonal - offset) / (breadth + diagonal - offset),
          ),
          TweenSequenceItem(
            tween: ConstantTween(diagonal),
            weight: 100 * breadth / (breadth + diagonal - offset),
          ),
        ]).animate(_animationController).value +
        1;

    var dr = breadth *
        (1 + (diagonal - offset) / breadth) *
        (_animation.value % (1 / (1 + (diagonal - offset) / breadth)));
    print('dr:' + dr.toString());
    print('maxradius:' + maxradius.toString());

    for (var i = 0;; i++) {
      double r = breadth * i + dr + offset;
      if (r > maxradius) {
        break;
      } else {
        canvas.drawCircle(c, r, paint);
      }
    }
    // count = percentage * diagonal % breadth;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _RipplesPainter1 extends CustomPainter {
  _RipplesPainter1(this._animationController)
      : super(repaint: _animationController) {
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }
  AnimationController _animationController;
  late Animation<double> _animation;
  double breadth = 30;
  double offset = 60;
  double count = 0;
  double firstWaveRadius = 60;
  int maxWave = 0;
  bool finished = false;

  @override
  void paint(Canvas canvas, Size size) {
    // print(_animationController.step);
    var percentage = _animation.value;
    // print(percentage);
    var width = size.width / 2;
    var height = size.height / 2;
    var maxradius = sqrt(width * width + height * height);

    var c = Offset(width, height);
    var paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (var i = 0;; i++) {
      var r = breadth * i + count + offset;
      if (r > maxradius) {
        break;
      } else {
        canvas.drawCircle(c, r, paint);
      }
    }

    count = percentage * breadth;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
