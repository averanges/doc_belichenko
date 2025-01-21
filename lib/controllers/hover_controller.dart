import 'package:doc_belichenko/common/consts.dart';
import 'package:doc_belichenko/common/helpers.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controller for hover effects
//This controller is used to apply hover effects to the [items] in the [Dock] widget
//It has two functions: onHover and resetHoverEffects and helper function _calculateScale

class HoverController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _hoveredController;

  AnimationController get hoveredController => _hoveredController;

  @override
  void onInit() {
    _hoveredController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.onInit();
  }

  @override
  void onClose() {
    _hoveredController.dispose();
    super.onClose();
  }

  // Function to apply hover effects
  // This function is called whenever the pointer moves over the [Dock] widget
  //The main idea is to scale items based on how far the pointer from center of item
  void onHover(PointerEvent event, List<ElementModel> items) {
    if (items.any((e) => e.isDragged)) return;

    _hoveredController.reset();
    final pointerPosition = event.position;

    for (int i = 0; i < items.length; i++) {
      try {
        final itemDetails = getRenderBoxDetails(items[i].key);

        final double distance = (pointerPosition - itemDetails.center).distance;

        final scale = _calculateScale(distance);
        items[i] = items[i].copyWith(scalingFactor: scale);
      } catch (e) {
        AppConsts.logger.e("Error processing item at index $i: $e");
      }
    }
    _hoveredController.forward();
  }

  // Function to reset hover effects
  // This function is called when the pointer leaves the [Dock] widget
  void resetHoverEffects(List<ElementModel> items) {
    _hoveredController.reset();

    for (int i = 0; i < items.length; i++) {
      items[i] = items[i].copyWith(scalingFactor: 1.0);
    }

    update();
  }

  // Function to calculate scaling based on distance
  // This function is called whenever the pointer moves over the [Dock] widget
  double _calculateScale(double distance) {
    const double maxDistance = 200.0;
    const double minScale = 1;
    const double maxScale = 1.12;

    if (distance > maxDistance) return minScale;
    return maxScale - ((distance / maxDistance) * (maxScale - minScale));
  }
}
