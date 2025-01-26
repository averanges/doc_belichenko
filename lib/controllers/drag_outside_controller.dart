import 'package:doc_belichenko/common/consts.dart';
import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/common/managers/logger.dart';
import 'package:doc_belichenko/common/utils/calculate_distance.dart';
import 'package:doc_belichenko/common/utils/create_new_render_box_model_from_key.dart';
import 'package:doc_belichenko/common/utils/find_dragged_index.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:doc_belichenko/models/item_render_box_model.dart';
import 'package:flutter/material.dart';

/// Controller for managing drag-and-drop operations when items are dragged outside their original area.
///
/// There are 2 main functions:
/// [placeDraggableBetweenItems] - called when the user drags an element outside [Dock] based on it's [ItemRenderBoxModel].
/// [onSwapLeave] - called when the user leaves the list or stops dragging an element inside the list.
class DragOutsideController {
  ///When user drags element back inside [Dock] calculate new position [Draggable]
  ///based on how close it is to every [ElementModel]. Swap position with closest to pointerPosition [ElementModel].
  void placeDraggableBetweenItems(Offset pointerPosition,
      List<ElementModel> items, GlobalKey containerKey) {
    int firstClosestIndex = -1;
    int secondClosestIndex = -1;

    try {
      (firstClosestIndex, secondClosestIndex) =
          _findClosestIndexes(pointerPosition: pointerPosition, items: items);

      if (firstClosestIndex == -1 || secondClosestIndex == -1) {
        return;
      }

      if (firstClosestIndex > secondClosestIndex) {
        final temp = firstClosestIndex;
        firstClosestIndex = secondClosestIndex;
        secondClosestIndex = temp;
      }

      final containerDetails = createNewRenderBoxModelFromKey(containerKey);

      final (distanceToLeft, distanceToRight) =
          _calculateDistanceForLeftAndRight(containerDetails, pointerPosition);

      final insertIndex = _calculateInsertIndex(
          distanceToLeft: distanceToLeft,
          distanceToRight: distanceToRight,
          firstClosestIndex: firstClosestIndex,
          items: items);

      final draggedIndex = findDraggedIndex(items);
      if (draggedIndex == null) return;
      _moveAndShiftPositions(draggedIndex, insertIndex, items);
    } catch (e) {
      LoggerBase.e("Error during drag outside: $e");
    }
  }

  (double distanceToLeft, double distanceToRight)
      _calculateDistanceForLeftAndRight(
          ItemRenderBoxModel item, Offset pointerPosition) {
    final leftBoundary = item.boundaries[Direction.left];
    final rightBoundary = item.boundaries[Direction.right];

    final distanceToLeft = (pointerPosition.dx - leftBoundary).abs();
    final distanceToRight = (pointerPosition.dx - rightBoundary).abs();

    return (distanceToLeft, distanceToRight);
  }

  (int firstClosestIndex, int secondClosestIndex) _findClosestIndexes(
      {required Offset pointerPosition, required List<ElementModel> items}) {
    int firstClosestIndex = -1;
    int secondClosestIndex = -1;
    double minDistance = double.maxFinite;
    double secondMinDistance = double.maxFinite;

    for (int i = 0; i < items.length; i++) {
      try {
        final itemDetails = items[i].renderBoxModel;

        if (itemDetails == null) {
          LoggerBase.e('RenderBox for item $i is null');
          continue;
        }

        final double distance =
            calculateDistance(pointerPosition, itemDetails.center);

        if (distance < minDistance) {
          secondMinDistance = minDistance;
          secondClosestIndex = firstClosestIndex;
          minDistance = distance;
          firstClosestIndex = i;
        } else if (distance < secondMinDistance) {
          secondMinDistance = distance;
          secondClosestIndex = i;
        }
      } catch (e) {
        LoggerBase.e("Error fetching details for item at index $i: $e");
      }
    }

    return (firstClosestIndex, secondClosestIndex);
  }

  int _calculateInsertIndex(
      {required double distanceToLeft,
      required double distanceToRight,
      required int firstClosestIndex,
      required List<ElementModel> items}) {
    int insertIndex;
    if (distanceToLeft < AppConsts.minimumDistanceThreshold) {
      insertIndex = 0;
    } else if (distanceToRight < AppConsts.minimumDistanceThreshold) {
      insertIndex = items.length;
    } else {
      insertIndex = firstClosestIndex + 1;
    }
    return insertIndex;
  }

  ///Switch not only position of [dragIndex] and [targetIndex] but all positions of other items.
  void _moveAndShiftPositions(
      int sourceIndex, int targetIndex, List<ElementModel> items) {
    if (sourceIndex == targetIndex) return;

    try {
      final endOffsets = items.map((e) => e.renderBoxModel?.endOffset).toList();
      final initialOffsets =
          items.map((e) => e.renderBoxModel?.initialOffset).toList();

      final draggedItem = items[sourceIndex];

      items.removeAt(sourceIndex);

      final adjustedTargetIndex =
          targetIndex > sourceIndex ? targetIndex - 1 : targetIndex;

      items.insert(adjustedTargetIndex, draggedItem);

      for (int i = 0; i < items.length; i++) {
        ElementModel.updateElementModelFromList(items, i,
            renderBoxModel: items[i].renderBoxModel?.updateOffset(
                recalculateCenter: true,
                newOffset: endOffsets[i],
                initialOffset: initialOffsets[i]));
      }
    } catch (e) {
      LoggerBase.e('Error: $e');
    }
  }
}
