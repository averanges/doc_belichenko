import 'package:doc_belichenko/common/enums.dart';
import 'package:flutter/material.dart';

double? calculateMovements(
    Direction? touchSide, Offset currentPosition, Offset targetCenter) {
  double movementDistance = 0.0;
  switch (touchSide) {
    case Direction.left:
      movementDistance = targetCenter.dx - currentPosition.dx;
      break;
    case Direction.right:
      movementDistance = currentPosition.dx - targetCenter.dx;
      break;
    case Direction.top:
      break;
    case Direction.bottom:
      break;
    default:
      break;
  }
  return movementDistance;
}
