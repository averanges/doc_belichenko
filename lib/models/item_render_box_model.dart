import 'package:doc_belichenko/common/enums.dart';
import 'package:flutter/material.dart';

class ItemRenderBoxModel {
  final RenderBox renderBox;
  final Offset globalPosition;
  final Size size;
  final Offset center;
  final Map<Direction, dynamic> boundaries;

  ItemRenderBoxModel({
    required this.renderBox,
    required this.globalPosition,
    required this.size,
    required this.center,
    required this.boundaries,
  });
}
