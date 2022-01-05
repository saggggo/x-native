import 'dart:math' as math;
import 'package:flutter/material.dart';

enum _ToolbarSlot {
  leading,
  middle,
  trailing,
}

class Toolbar extends StatelessWidget {
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;

  Toolbar({this.leading, this.middle, this.trailing});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      height: 40,
      child: CustomMultiChildLayout(
        delegate: _ToolbarLayout(40),
        children: <Widget>[
          if (leading != null)
            LayoutId(id: _ToolbarSlot.leading, child: leading!),
          if (middle != null) LayoutId(id: _ToolbarSlot.middle, child: middle!),
          if (trailing != null)
            LayoutId(id: _ToolbarSlot.trailing, child: trailing!),
        ],
      ),
    );
  }
}

class _ToolbarLayout extends MultiChildLayoutDelegate {
  final double height;
  _ToolbarLayout(this.height);

  @override
  void performLayout(Size size) {
    double leadingWidth = 0;
    double trailingWidth = 0;

    if (hasChild(_ToolbarSlot.leading)) {
      final BoxConstraints constraints = BoxConstraints(
        maxWidth: size.width / 3.0,
        minHeight: size.height,
        maxHeight: size.height,
      );
      final Size leadingSize = layoutChild(_ToolbarSlot.leading, constraints);
      leadingWidth = leadingSize.width;
      final double trailingX = size.width - leadingSize.width;
      final double trailingY = (size.height - leadingSize.height) / 2.0;
      positionChild(_ToolbarSlot.trailing, Offset(trailingX, trailingY));
    }

    if (hasChild(_ToolbarSlot.trailing)) {
      final BoxConstraints constraints = BoxConstraints(
        maxWidth: size.width / 3.0,
        minHeight: size.height,
        maxHeight: size.height,
      );
      final Size trailingSize = layoutChild(_ToolbarSlot.trailing, constraints);
      trailingWidth = trailingSize.width;
      final double trailingX = size.width - trailingSize.width;
      final double trailingY = (size.height - trailingSize.height) / 2.0;
      positionChild(_ToolbarSlot.trailing, Offset(trailingX, trailingY));
    }

    if (hasChild(_ToolbarSlot.middle)) {
      final double maxWidth =
          math.max(size.width - leadingWidth - trailingWidth, 0.0);
      final BoxConstraints constraints =
          BoxConstraints.loose(size).copyWith(maxWidth: maxWidth);
      final Size middleSize = layoutChild(_ToolbarSlot.middle, constraints);

      final double middleY = (size.height - middleSize.height) / 2.0;
      final double middleX;
      final double middleStart = (size.width - middleSize.width) / 2;
      middleX = middleStart;
      positionChild(_ToolbarSlot.middle, Offset(middleX, middleY));
    }
  }

  @override
  bool shouldRelayout(_ToolbarLayout oldDelegate) {
    return oldDelegate.height != height;
  }
}
