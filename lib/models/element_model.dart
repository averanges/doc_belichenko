import 'package:flutter/material.dart';

class ElementModel {
  final String id;
  final IconData icon;
  final Color color;
  final GlobalKey key;
  final double scalingFactor;
  final Offset initialOffset;
  final Offset endOffset;
  final Offset centerOffset;
  final bool isDragged;
  final bool isAnimated;
  final AnimationController? animationController;
  ElementModel(
      {required this.id,
      required this.icon,
      required this.key,
      this.color = Colors.transparent,
      this.scalingFactor = 1.0,
      this.initialOffset = Offset.zero,
      this.endOffset = Offset.zero,
      this.centerOffset = Offset.zero,
      this.isDragged = false,
      this.isAnimated = false,
      this.animationController});

  ElementModel copyWith(
          {String? id,
          IconData? icon,
          Color? color,
          GlobalKey? key,
          int? currentIndex,
          double? scalingFactor,
          Offset? initialOffset,
          Offset? endOffset,
          Offset? centerOffset,
          bool? isDragged,
          bool? isAnimated,
          AnimationController? animationController}) =>
      ElementModel(
          id: id ?? this.id,
          icon: icon ?? this.icon,
          key: key ?? this.key,
          color: color ?? this.color,
          scalingFactor: scalingFactor ?? this.scalingFactor,
          initialOffset: initialOffset ?? this.initialOffset,
          endOffset: endOffset ?? this.endOffset,
          centerOffset: centerOffset ?? this.centerOffset,
          isDragged: isDragged ?? this.isDragged,
          isAnimated: isAnimated ?? this.isAnimated,
          animationController: animationController ?? this.animationController);
}
