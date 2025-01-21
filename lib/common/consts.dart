import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

//Static default list of elements.
//For this test task i used hardcoded values
//In real app i would get this list from the backend
List<ElementModel> defaultElements = [
  ElementModel(
      icon: Icons.person,
      key: GlobalKey(),
      id: Icons.person.hashCode.toString()),
  ElementModel(
      icon: Icons.message,
      key: GlobalKey(),
      id: Icons.message.hashCode.toString()),
  ElementModel(
      icon: Icons.call, key: GlobalKey(), id: Icons.call.hashCode.toString()),
  ElementModel(
      icon: Icons.camera,
      key: GlobalKey(),
      id: Icons.camera.hashCode.toString()),
  ElementModel(
      icon: Icons.photo, key: GlobalKey(), id: Icons.photo.hashCode.toString()),
];

//Static constants
class AppConsts {
  static const double itemWidth = 48.0;
  static const double itemHeight = 48.0;
  static const double itemSpacing = 8.0;
  static const double itemBorderRadius = 8.0;
  static const double padding = 4.0;

  static const Color containerColor = Colors.black12;
  static const Color iconColor = Colors.white;

  static GlobalKey containerKey = GlobalKey();

  static Logger logger = Logger();
}
