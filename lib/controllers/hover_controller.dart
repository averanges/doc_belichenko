import 'package:doc_belichenko/common/managers/animation_manager.dart';
import 'package:doc_belichenko/common/managers/logger.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';

///Controller for hover effects.
///
///This controller is used to apply hover effects to the [ElementModel]s based on scalingFactor.
///[onHover] - called when the user hovers over an [ElementModel].
///[resetHoverEffects] - called when the user stops hovering over any [ElementModel].

class HoverController {
  final AnimationController _animationController =
      AnimationManager.instance.hoverController;
  AnimationController get hoveredController => _animationController;

  void onHover(PointerEvent event, List<ElementModel> items) {
    if (items.any((e) => e.isDragged)) return;

    _animationController.reset();
    final pointerPosition = event.position;

    for (int i = 0; i < items.length; i++) {
      try {
        final itemDetails = items[i].renderBoxModel;

        if (itemDetails == null) {
          LoggerBase.e('RenderBox for item $i is null');
          continue;
        }

        final double distance = (pointerPosition - itemDetails.center).distance;

        final scale = _calculateScale(distance);
        ElementModel.updateElementModelFromList(
          items,
          i,
          scalingFactor: scale,
        );
        _animationController.forward();
      } catch (e) {
        LoggerBase.e("Error processing item at index $i: $e");
      }
    }
  }

  void resetHoverEffects(List<ElementModel> items) {
    _animationController.reset();

    for (int i = 0; i < items.length; i++) {
      ElementModel.updateElementModelFromList(
        items,
        i,
        scalingFactor: 1.0,
      );
    }
  }

  double _calculateScale(double distance) {
    const double maxDistance = 200.0;
    const double minScale = 1;
    const double maxScale = 1.12;

    if (distance > maxDistance) return minScale;
    return maxScale - ((distance / maxDistance) * (maxScale - minScale));
  }
}
