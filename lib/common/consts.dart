import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';

///Static default list of elements [ElementModel].
List<ElementModel> defaultElements = [
  ElementModel(
    icon: Icons.person,
  ),
  ElementModel(
    icon: Icons.message,
  ),
  ElementModel(icon: Icons.call),
  ElementModel(
    icon: Icons.camera,
  ),
  ElementModel(icon: Icons.photo),
];

///Static constants
class AppConsts {
  ///UI
  static const double itemWidth = 48.0;
  static const double itemHeight = 48.0;
  static const double itemSpacing = 8.0;
  static const double itemBorderRadius = 8.0;
  static const double padding = 4.0;

  static const Color containerColor = Colors.black12;
  static const Color iconColor = Colors.white;

  ///Animation
  static const Duration animationDuration = Duration(milliseconds: 200);

  ///Thresholds
  static const double minimumDistanceThreshold = 20.0;
  static const double swapThreshold = 50.0;
}
