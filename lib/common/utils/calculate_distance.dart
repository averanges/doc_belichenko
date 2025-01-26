import 'package:flutter/material.dart';

double calculateDistance(Offset point1, Offset point2) {
  return (point1 - point2).distance;
}
