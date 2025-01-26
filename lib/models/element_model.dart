import 'package:doc_belichenko/models/item_render_box_model.dart';
import 'package:flutter/material.dart';

///Main model to handle elements of [Dock].
///
///Contains renderbox information using [ItemRenderBoxModel].
///Store [GlobalKey] to access the renderbox using its key.
///And [AnimationController] assign to each element.
///[isAnimated] flag activates when [DragInsideController] function [updatePosition] is called to animate the element.
///[isScaling] flag activates when [HoverController] function [onHover] is called to animate the element.
///[isDragged] flag is true when the element is started to be dragged.
class ElementModel {
  final String id;
  final IconData icon;
  final Color color;
  final GlobalKey? key;
  final double scalingFactor;
  final bool isDragged;
  final bool isAnimated;
  final AnimationController? animationController;
  final ItemRenderBoxModel? renderBoxModel;

  ElementModel({
    required this.icon,
    this.key,
    this.scalingFactor = 1.0,
    this.isDragged = false,
    this.isAnimated = false,
    this.animationController,
    this.renderBoxModel,
  })  : id = icon.hashCode.toString(),
        color = Colors.primaries[icon.hashCode % Colors.primaries.length];

  ElementModel copyWith({
    IconData? icon,
    GlobalKey? key,
    double? scalingFactor,
    bool? isDragged,
    bool? isAnimated,
    AnimationController? animationController,
    ItemRenderBoxModel? renderBoxModel,
  }) =>
      ElementModel(
        icon: icon ?? this.icon,
        key: key ?? this.key,
        scalingFactor: scalingFactor ?? this.scalingFactor,
        isDragged: isDragged ?? this.isDragged,
        isAnimated: isAnimated ?? this.isAnimated,
        animationController: animationController ?? this.animationController,
        renderBoxModel: renderBoxModel ?? this.renderBoxModel,
      );

  static void updateElementModelFromList(List<ElementModel> items, int index,
      {GlobalKey? key,
      double? scalingFactor,
      bool? isDragged,
      bool? isAnimated,
      AnimationController? animationController,
      ItemRenderBoxModel? renderBoxModel}) {
    items[index] = items[index].copyWith(
        key: key,
        scalingFactor: scalingFactor,
        isDragged: isDragged,
        isAnimated: isAnimated,
        animationController: animationController,
        renderBoxModel: renderBoxModel);
  }
}
