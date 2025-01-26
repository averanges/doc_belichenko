import 'package:doc_belichenko/common/enums.dart';
import 'package:flutter/material.dart';

///[RenderBox] information handling class.
///
///[initialOffset] is [Offset] initiate on Init stage.
///[endOffset] is [Offset] that used when [DragInsideController] function [updatePosition] is called to swap elements.
class ItemRenderBoxModel {
  final RenderBox renderBox;
  final Offset initialOffset;
  final Offset endOffset;
  final Size size;
  final Offset center;
  final Map<Direction, dynamic> boundaries;

  ItemRenderBoxModel({
    required this.renderBox,
    required this.initialOffset,
    required this.endOffset,
    required this.size,
    required this.center,
    required this.boundaries,
  });

  static ItemRenderBoxModel fromRenderBox(RenderBox renderBox) {
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final center = calculateCenterOffset(position, size);

    return ItemRenderBoxModel(
      renderBox: renderBox,
      initialOffset: position,
      endOffset: position,
      size: size,
      center: center,
      boundaries: {
        Direction.left: position.dx,
        Direction.top: position.dy,
        Direction.right: position.dx + size.width,
        Direction.bottom: position.dy + size.height,
      },
    );
  }

  static Offset calculateCenterOffset(Offset position, Size size) =>
      position + Offset(size.width / 2, size.height / 2);

  ItemRenderBoxModel copyWith({
    RenderBox? renderBox,
    Offset? initialOffset,
    Offset? endOffset,
    Size? size,
    Offset? center,
    Map<Direction, dynamic>? boundaries,
  }) {
    return ItemRenderBoxModel(
      renderBox: renderBox ?? this.renderBox,
      initialOffset: initialOffset ?? this.initialOffset,
      endOffset: endOffset ?? this.endOffset,
      size: size ?? this.size,
      center: center ?? this.center,
      boundaries: boundaries ?? this.boundaries,
    );
  }

  ItemRenderBoxModel updateOffset({
    Offset? newOffset,
    Offset? initialOffset,
    required bool recalculateCenter,
  }) {
    return copyWith(
      initialOffset: initialOffset ?? initialOffset,
      endOffset: newOffset ?? endOffset,
      center: recalculateCenter
          ? calculateCenterOffset(newOffset ?? endOffset, size)
          : center,
    );
  }
}
