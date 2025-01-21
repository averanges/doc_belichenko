import 'package:doc_belichenko/common/consts.dart';
import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//[DockItem] uses [DragTarget] and [Draggable] widgets to build a draggable item within a container.
//The [DragTarget] listens for drag operations and updates the position of the draggable item accordingly.
//The [Draggable] allows the user to drag the item and triggers the necessary updates when the drag operation ends.
//The [Draggable] contains 3 widget states: [childWhenDragging] original position while dragging,
//[feedback] the actual draggable item, and [child] the original item without dragging.
//To control animation we use combination of 2 [AnimatedBuilder] widgets.
//One for animating the position of the draggable item,
//and the other for animating the scaling factor of the draggable item when it's hovered over.
class DockItem extends StatelessWidget {
  const DockItem(
      {super.key,
      required this.index,
      required this.icon,
      required this.color,
      required this.controller});
  final int index;
  final IconData icon;
  final Color color;
  final Controller controller;

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
        data: index,
        onDragStarted: () => controller.onDragStarted(index),
        onDragEnd: (details) => controller.onDragEnd(),
        onDragUpdate: (details) =>
            controller.onDragUpdate(details.globalPosition),
        feedback: _buildDraggableItem(icon),
        childWhenDragging: _buildDragPlaceholder(icon),
        child: _buildItem(icon));
  }

  Widget _buildDragPlaceholder(IconData icon) {
    return DragTarget<int>(
      builder: (context, candidateData, rejectedData) => Obx(
        () {
          final isInside = controller.dragInfo == null ||
              controller.dragInfo?.currentDragState == DragState.inside;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isInside ? AppConsts.itemWidth : 0,
            height: AppConsts.itemHeight,
            margin: EdgeInsets.all(isInside ? AppConsts.itemSpacing : 0),
          );
        },
      ),
    );
  }

  Widget _buildDraggableItem(IconData icon) {
    return Container(
      constraints: const BoxConstraints(minWidth: AppConsts.itemWidth),
      height: AppConsts.itemHeight,
      margin: const EdgeInsets.all(AppConsts.itemSpacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConsts.itemBorderRadius),
        color: color,
      ),
      child: Center(child: Icon(icon, color: AppConsts.iconColor)),
    );
  }

  Widget _buildItem(IconData icon) {
    return AnimatedBuilder(
        animation: controller.items[index].animationController!,
        builder: (context, child) {
          final item = controller.items[index];
          final Offset animatedOffset = item.isAnimated
              ? Tween<Offset>(
                      begin: Offset.zero,
                      end: item.endOffset - item.initialOffset)
                  .animate(item.animationController!)
                  .value
              : Offset.zero;
          return DragTarget<int>(
            onMove: (details) {
              controller.onSwapStarted(details.offset, index);
              controller.onSwapUpdate(
                currentPosition: details.offset,
                targetIndex: index,
              );
            },
            onLeave: (details) => controller.onSwapLeave(),
            builder: (context, candidateData, rejectedData) =>
                Transform.translate(
              offset: animatedOffset,
              child: AnimatedBuilder(
                animation: controller.hoveredController,
                builder: (context, child) => Transform.scale(
                  scale: controller.items[index].scalingFactor,
                  child: _buildDraggableItem(icon),
                ),
              ),
            ),
          );
        });
  }
}
