import 'package:doc_belichenko/common/consts.dart';
import 'package:doc_belichenko/common/helpers.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';

//Simple controller for initializing items models
//It contains 3 functions: initializeItemsModels, calculateItemInitialOffsets and calculateItemCenters
//It is used to initialize items models, calculate initial offsets and centers
class InitActionsController {
  void initializeItemsModels(List<ElementModel> items, TickerProvider ticker) {
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      items[i] = item.copyWith(
          currentIndex: i,
          animationController: createNewAnimationController(ticker),
          color:
              Colors.primaries[item.icon.hashCode % Colors.primaries.length]);
    }
  }

  void calculateItemInitialOffsets(List<ElementModel> items) {
    for (int i = 0; i < items.length; i++) {
      final key = items[i].key;
      final context = key.currentContext;
      if (context == null) {
        AppConsts.logger.e('Context for item $i is null');
        continue;
      }
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        items[i] = items[i].copyWith(
          initialOffset: position,
          endOffset: position,
        );
      } else {
        AppConsts.logger.e('RenderBox for item $i is null');
      }
    }
  }

  void calculateItemCenters(List<ElementModel> items) {
    for (int i = 0; i < items.length; i++) {
      final Offset initialPosition = items[i].initialOffset;
      final context = items[i].key.currentContext;
      if (context == null) {
        AppConsts.logger.e('Context for item $i is null');
        continue;
      }
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final centerOffset = initialPosition +
          Offset(renderBox.size.width / 2, renderBox.size.height / 2);
      items[i] = items[i].copyWith(centerOffset: centerOffset);
    }
  }
}
