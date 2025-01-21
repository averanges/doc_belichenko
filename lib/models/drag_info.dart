import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';

class DragInfo {
  int draggedIndex;
  DragState currentDragState;
  DragState previousDragState;
  bool isPlacedBetweenItemsActive;

  DragInfo({
    required this.draggedIndex,
    this.currentDragState = DragState.inside,
    this.previousDragState = DragState.inside,
    this.isPlacedBetweenItemsActive = false,
  });

  static DragState calculateDragState(
      GlobalKey containerKey, Offset mousePosition) {
    final containerRenderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    final containerPosition = containerRenderBox.localToGlobal(Offset.zero);
    final containerSize = containerRenderBox.size;

    if (mousePosition.dx < containerPosition.dx ||
        mousePosition.dx > containerPosition.dx + containerSize.width ||
        mousePosition.dy < containerPosition.dy ||
        mousePosition.dy > containerPosition.dy + containerSize.height) {
      return DragState.outside;
    } else {
      return DragState.inside;
    }
  }

  DragInfo copyWith({
    int? draggedIndex,
    DragState? currentDragState,
    DragState? previousDragState,
    bool? isPlacedBetweenItemsActive,
  }) {
    return DragInfo(
      draggedIndex: draggedIndex ?? this.draggedIndex,
      currentDragState: currentDragState ?? this.currentDragState,
      previousDragState: previousDragState ?? this.previousDragState,
      isPlacedBetweenItemsActive:
          isPlacedBetweenItemsActive ?? this.isPlacedBetweenItemsActive,
    );
  }

  static int findDraggedIndex(List<ElementModel> items) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].isDragged) {
        return i;
      }
    }
    return -1;
  }
}
