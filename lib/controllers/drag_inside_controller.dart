import 'package:doc_belichenko/common/consts.dart';
import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/common/managers/animation_manager.dart';
import 'package:doc_belichenko/common/managers/queue_mixin.dart';
import 'package:doc_belichenko/common/utils/calculate_movements.dart';
import 'package:doc_belichenko/common/utils/find_dragged_index.dart';
import 'package:doc_belichenko/common/utils/find_touch_side.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///Controller for managing drag-inside / swap operations within a list of elements.
///
///There 3 main functions:
///[onSwapStarted] - called when the user starts dragging an element inside the list.
///[onSwapUpdate] - called when the user drags an element inside the list.
///[onSwapLeave] - called when the user leaves the list or stops dragging an element inside the list.
class DragInsideController extends GetxController with QueueProcessorMixin {
  Offset? _initialTouchPosition;
  int? _currentTargetIndex;
  Direction? _touchSide;

  ///Called when  [Draggable] touches [DragTarget] widget.
  void onSwapStarted(
      Offset touchPosition, int targetIndex, List<ElementModel> items) {
    _initialTouchPosition = touchPosition;
    _currentTargetIndex = targetIndex;

    _touchSide = findTouchSide(touchPosition, items[targetIndex]);
  }

  ///Called when the user move [Draggable] over [DragTarget] widget.
  ///
  ///[calculateMovements] determines which [Direction] current [Draggable] is moving.
  ///and return current moved distance it triggers [updatePosition] if the distance is greater than [AppConsts.swapThreshold].
  void onSwapUpdate(
      {required Offset currentPosition,
      required int targetIndex,
      required List<ElementModel> items,
      bool isPlacedBetweenItemsActive = false}) {
    if (_initialTouchPosition == null || _currentTargetIndex != targetIndex) {
      return;
    }
    if (isPlacedBetweenItemsActive) return;

    final targetCenter = items[targetIndex].renderBoxModel?.center;

    if (targetCenter == null) return;

    final movementDistance =
        calculateMovements(_touchSide, currentPosition, targetCenter);

    if (movementDistance == null) return;

    if (movementDistance > AppConsts.swapThreshold) {
      _updatePosition(targetIndex, items);
      _initialTouchPosition = null;
      _currentTargetIndex = null;
      _touchSide = null;
    }
  }

  ///Triggers [AnimationController] and updates the positions of the dragged and target items in order of [QueueProcessorMixin].
  void _updatePosition(int targetIndex, List<ElementModel> items) {
    addFunctionToQueue(() async {
      final draggedIndex = findDraggedIndex(items);
      if (draggedIndex == null || targetIndex == draggedIndex) return;
      if ((targetIndex - draggedIndex).abs() != 1) return;

      final targetItem = items[targetIndex];

      _prepareItemsForAnimation(draggedIndex, targetIndex, items);

      await targetItem.animationController?.forward(from: 0);

      _updateInternalPropertiesAfterAnimation(draggedIndex, targetIndex, items);

      _swapItems(draggedIndex, targetIndex, items);

      _disposeAnimationController(targetItem);
    });

    processQueue();
  }

  /// Swap only endOffset in [ItemRenderBoxModel] of [ElementModel] to be able to animate.
  void _prepareItemsForAnimation(
      int draggedIndex, int targetIndex, List<ElementModel> items) {
    _updateItemsPositions(
      firstIndex: targetIndex,
      secondIndex: draggedIndex,
      items: items,
      isAnimated: true,
    );
    _updateItemsPositions(
      firstIndex: draggedIndex,
      secondIndex: targetIndex,
      items: items,
      isAnimated: false,
    );
  }

  void _updateItemsPositions({
    required int firstIndex,
    required int secondIndex,
    required List<ElementModel> items,
    required bool isAnimated,
  }) {
    final itemToUpdate = items[firstIndex];
    final itemToSwap = items[secondIndex];
    ElementModel.updateElementModelFromList(
      items,
      firstIndex,
      isAnimated: isAnimated,
      renderBoxModel: itemToUpdate.renderBoxModel?.updateOffset(
        recalculateCenter: true,
        newOffset: itemToSwap.renderBoxModel?.initialOffset,
      ),
    );
  }

  ///Completely updates [ItemRenderBoxModel] of [ElementModel] after animation.
  void _updateInternalPropertiesAfterAnimation(
      int draggedIndex, int targetIndex, List<ElementModel> items) {
    final draggedItem = items[draggedIndex];
    final targetItem = items[targetIndex];

    ElementModel.updateElementModelFromList(
      items,
      draggedIndex,
      renderBoxModel: draggedItem.renderBoxModel?.updateOffset(
        recalculateCenter: true,
        newOffset: targetItem.renderBoxModel?.initialOffset,
        initialOffset: targetItem.renderBoxModel?.initialOffset,
      ),
    );

    ElementModel.updateElementModelFromList(
      items,
      targetIndex,
      renderBoxModel: targetItem.renderBoxModel?.updateOffset(
        recalculateCenter: true,
        newOffset: draggedItem.renderBoxModel?.initialOffset,
        initialOffset: draggedItem.renderBoxModel?.initialOffset,
      ),
      isAnimated: false,
      animationController:
          AnimationManager.instance.createNewAnimationController(),
    );
  }

  void _disposeAnimationController(ElementModel targetItem) {
    targetItem.animationController?.reset();
    targetItem.animationController?.dispose();
  }

  void _swapItems(int draggedIndex, int targetIndex, List<ElementModel> items) {
    final temp = items[draggedIndex];
    items[draggedIndex] = items[targetIndex];
    items[targetIndex] = temp;
  }

  void clearQueueOutside() {
    clearQueue();
  }

  void onSwapLeave() {
    _initialTouchPosition = null;
    _currentTargetIndex = null;
    _touchSide = null;
  }
}
