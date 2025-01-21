import 'dart:collection';

import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/common/helpers.dart';
import 'package:doc_belichenko/models/drag_info.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller for managing drag-and-drop operations within a list of elements.
// This controller handles the logic for swapping items when dragged inside a target area.
class DragInsideController extends GetxController {
  Offset? _initialTouchPosition;
  int? _currentTargetIndex;
  Direction? _touchSide;

  final Queue<Future Function()> _functionQueue = Queue();
  bool _isProcessingQueue = false;

  Queue<Future Function()> get functionQueue => _functionQueue;
  bool get isProcessingQueue => _isProcessingQueue;

  set isProcessingQueue(bool value) {
    _isProcessingQueue = value;
    update();
  }

  // Resets the initial touch position, current target index, and touch side when a swap operation is canceled.
  void onSwapLeave() {
    _initialTouchPosition = null;
    _currentTargetIndex = null;
    _touchSide = null;
  }

  // Initializes the swap operation with the touch position and target index.
  // Determines the side of the drag target that was touched based on the touch position.
  void onSwapStarted(
      Offset touchPosition, int targetIndex, List<ElementModel> items) {
    _initialTouchPosition = touchPosition;
    _currentTargetIndex = targetIndex;

    final targetCenter = items[targetIndex].centerOffset;
    if ((touchPosition.dx - targetCenter.dx).abs() >
        (touchPosition.dy - targetCenter.dy).abs()) {
      _touchSide =
          touchPosition.dx < targetCenter.dx ? Direction.left : Direction.right;
    } else {
      _touchSide =
          touchPosition.dy < targetCenter.dy ? Direction.top : Direction.bottom;
    }
  }

  // Updates the position of the draggable item based on the current touch position.
  //Do not start immediate
  // Only updates if the draggable has crossed a threshold to trigger a swap operation.
  void onSwapUpdate(
      {required Offset currentPosition,
      required int targetIndex,
      required TickerProvider ticker,
      required List<ElementModel> items,
      bool isPlacedBetweenItemsActive = false}) {
    if (_initialTouchPosition == null || _currentTargetIndex != targetIndex) {
      return;
    }
    if (isPlacedBetweenItemsActive) return;

    final targetCenter = items[targetIndex].centerOffset;
    double movementDistance = 0.0;
    switch (_touchSide) {
      case Direction.left:
        movementDistance = targetCenter.dx - currentPosition.dx;
        break;
      case Direction.right:
        movementDistance = currentPosition.dx - targetCenter.dx;
        break;
      case Direction.top:
        return;
      case Direction.bottom:
        return;
      default:
        return;
    }

    const double threshold = 50.0;
    if (movementDistance > threshold) {
      updatePosition(targetIndex, items, ticker);
      _initialTouchPosition = null;
      _currentTargetIndex = null;
      _touchSide = null;
    }
  }

  // Updates the position of the dragged item and manages animations.
  // Adds the operation to the queue for processing.
  //The main idea pf using queue to prevent all animations happens at the same time
  void updatePosition(
      int targetIndex, List<ElementModel> items, TickerProvider ticker) {
    _functionQueue.add(() async {
      final draggedIndex = DragInfo.findDraggedIndex(items);
      if (draggedIndex == -1 || targetIndex == draggedIndex) return;

      if ((targetIndex - draggedIndex).abs() != 1) return;

      final draggedItem = items[draggedIndex];
      final targetItem = items[targetIndex];

      // Update endOffsets for smooth animation
      items[targetIndex] = targetItem.copyWith(
        isAnimated: true,
        endOffset: draggedItem.initialOffset,
      );

      items[draggedIndex] = draggedItem.copyWith(
        isAnimated: false,
        endOffset: targetItem.initialOffset,
      );

      items.reactive.refresh();
      if (targetItem.animationController == null || !targetItem.isAnimated) {
        debugPrint('animation not started');
      }

      await targetItem.animationController?.forward(from: 0);

      // Swap internal properties of both elements after animation
      items[draggedIndex] = draggedItem.copyWith(
        initialOffset: targetItem.initialOffset,
        centerOffset: targetItem.centerOffset,
        endOffset: Offset.zero,
      );

      items[targetIndex] = targetItem.copyWith(
        initialOffset: draggedItem.initialOffset,
        centerOffset: draggedItem.centerOffset,
        animationController: createNewAnimationController(ticker),
        isAnimated: false,
        endOffset: Offset.zero,
      );

      // Swap items in the list
      final temp = items[draggedIndex];
      items[draggedIndex] = items[targetIndex];
      items[targetIndex] = temp;

      // Dispose the animation controller
      targetItem.animationController?.reset();
      targetItem.animationController?.dispose();
    });

    if (!_isProcessingQueue) {
      _processQueue();
    }
  }

  // Processes queued operations for drag-and-drop actions.
  void _processQueue() async {
    if (_isProcessingQueue) return;
    _isProcessingQueue = true;

    while (_functionQueue.isNotEmpty) {
      final function = _functionQueue.removeFirst();
      await function();
    }

    _isProcessingQueue = false;
  }
}
