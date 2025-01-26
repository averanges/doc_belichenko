import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';

Direction? findTouchSide(Offset touchPosition, ElementModel item) {
  final targetCenter = item.renderBoxModel?.center;
  if (targetCenter == null) return null;
  if ((touchPosition.dx - targetCenter.dx).abs() >
      (touchPosition.dy - targetCenter.dy).abs()) {
    return touchPosition.dx < targetCenter.dx
        ? Direction.left
        : Direction.right;
  } else {
    return touchPosition.dy < targetCenter.dy
        ? Direction.top
        : Direction.bottom;
  }
}
