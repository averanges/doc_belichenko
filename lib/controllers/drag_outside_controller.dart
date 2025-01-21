import 'package:doc_belichenko/common/consts.dart';
import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/common/helpers.dart';
import 'package:doc_belichenko/models/drag_info.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';

// Controller for managing drag-and-drop operations when items are dragged outside their original area.
// This controller handles the logic for placing draggable items between existing items in a list.
class DragOutsideController {
  // Places the draggable item between existing items based on the pointer position.
  // It calculates the closest items and determines where to insert the draggable item.
  // Basically it places the [childWhenDragging] between the closest items
  // but [feedback] remains the same
  void placeDraggableBetweenItems(
      Offset pointerPosition, List<ElementModel> items) {
    int firstClosestIndex = -1;
    int secondClosestIndex = -1;
    double minDistance = double.infinity;
    double secondMinDistance = double.infinity;

    final GlobalKey containerKey = AppConsts.containerKey;

    try {
      final containerDetails = getRenderBoxDetails(containerKey);
      final leftBoundary = containerDetails.boundaries[Direction.left];
      final rightBoundary = containerDetails.boundaries[Direction.right];

      final distanceToLeft = (pointerPosition.dx - leftBoundary).abs();
      final distanceToRight = (pointerPosition.dx - rightBoundary).abs();

      for (int i = 0; i < items.length; i++) {
        try {
          final itemDetails = getRenderBoxDetails(items[i].key);

          final double distance =
              (pointerPosition - itemDetails.center).distance;

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
          AppConsts.logger.e("Error fetching details for item at index $i: $e");
        }
      }

      if (firstClosestIndex == -1 || secondClosestIndex == -1) {
        return;
      }

      if (firstClosestIndex > secondClosestIndex) {
        final temp = firstClosestIndex;
        firstClosestIndex = secondClosestIndex;
        secondClosestIndex = temp;
      }

      int insertIndex;
      if (distanceToLeft < distanceToRight && distanceToLeft < minDistance) {
        insertIndex = 0;
      } else if (distanceToRight < distanceToLeft &&
          distanceToRight < minDistance) {
        insertIndex = items.length;
      } else {
        insertIndex = firstClosestIndex + 1;
      }

      final draggedIndex = DragInfo.findDraggedIndex(items);
      if (draggedIndex != -1) {
        moveAndShiftPositions(draggedIndex, insertIndex, items);
      }
    } catch (e) {
      AppConsts.logger.e("Error during drag outside: $e");
    }
  }

  // Moves and shifts the positions of items in the list based on the source and target indices.
  // This function updates the offsets of the items to maintain their positions correctly.
  void moveAndShiftPositions(
      int sourceIndex, int targetIndex, List<ElementModel> items) {
    if (sourceIndex == targetIndex) return;

    try {
      final initialOffsets = items.map((e) => e.endOffset).toList();
      final centerOffsets = items.map((e) => e.centerOffset).toList();
      final startOffsets = items.map((e) => e.initialOffset).toList();

      final draggedItem = items[sourceIndex];

      items.removeAt(sourceIndex);

      final adjustedTargetIndex =
          targetIndex > sourceIndex ? targetIndex - 1 : targetIndex;

      items.insert(adjustedTargetIndex, draggedItem);

      for (int i = 0; i < items.length; i++) {
        items[i] = items[i].copyWith(
          endOffset: initialOffsets[i],
          initialOffset: startOffsets[i],
          centerOffset: centerOffsets[i],
        );
      }
    } catch (e) {
      AppConsts.logger.e('Error: $e');
    }
  }
}
