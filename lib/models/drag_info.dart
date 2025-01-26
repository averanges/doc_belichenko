import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';

/// [DragInfo] class to handle [Draggable].
///
/// This class contains the information about the current state of a [Draggable].
/// [isPlacedBetweenItemsActive] is a flag that indicates whether
/// the [DragOutsideController] function [placeDraggableBetweenItems] is currently active.
/// [endDragPosition] is the last position of mouse pointer when [Draggable] is released.
/// [DragState] is the current state of [Draggable] either [inside] or [outside] of [Dock].
class DragInfo {
  int draggedIndex;
  DragState currentDragState;
  DragState previousDragState;
  bool isPlacedBetweenItemsActive;
  ElementModel? element;
  Offset? endDragPosition;

  DragInfo({
    required this.draggedIndex,
    this.currentDragState = DragState.inside,
    this.previousDragState = DragState.inside,
    this.isPlacedBetweenItemsActive = false,
    this.element,
    this.endDragPosition,
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
    ElementModel? element,
    Offset? endDragPosition,
  }) {
    return DragInfo(
        draggedIndex: draggedIndex ?? this.draggedIndex,
        currentDragState: currentDragState ?? this.currentDragState,
        previousDragState: previousDragState ?? this.previousDragState,
        isPlacedBetweenItemsActive:
            isPlacedBetweenItemsActive ?? this.isPlacedBetweenItemsActive,
        element: element ?? this.element,
        endDragPosition: endDragPosition ?? this.endDragPosition);
  }

  static DragInfo createNewDragInfo(int index, ElementModel element) {
    return DragInfo(
      draggedIndex: index,
      endDragPosition: null,
      element: element,
      currentDragState: DragState.inside,
      previousDragState: DragState.inside,
    );
  }
}
