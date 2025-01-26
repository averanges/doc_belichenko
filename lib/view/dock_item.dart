import 'package:doc_belichenko/common/consts.dart';
import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/common/utils/calculate_animated_offset.dart';
import 'package:doc_belichenko/common/utils/find_dragged_index.dart';
import 'package:doc_belichenko/controllers/controller.dart';
import 'package:doc_belichenko/view/icon_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///[Draggable] and [DragTarget] widgets for each item in the [Dock].
///
///[Draggable] is used to move an item from the [Dock] to another position.
///[DragTarget] is used to check if the [Draggable] moved over this position.
///[Draggable] has 3 states: initial, dragging, whileDragging.
///[_buildItem] is used to build the initial [Draggable] when no drag action is performed on this widget.
///[_buildDragPlaceholder] is used to build the [Draggable] while dragging on initial position.
///[_buildDraggableItem] is used to build the [Draggable] while dragging following mouse pointer.
///
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
            duration: AppConsts.animationDuration,
            width: isInside ? AppConsts.itemWidth : 0,
            height: AppConsts.itemHeight,
            margin: EdgeInsets.all(isInside ? AppConsts.itemSpacing : 0),
          );
        },
      ),
    );
  }

  Widget _buildDraggableItem(IconData icon) {
    return Obx(
      () {
        final currentIndex = findDraggedIndex(controller.items) ??
            controller.dragInfo?.draggedIndex;
        return Opacity(
          opacity: currentIndex == index &&
                  controller.isCanceled &&
                  controller.dragInfo?.currentDragState == DragState.outside
              ? 0
              : 1,
          child: IconItem(
            icon: icon,
            color: color,
          ),
        );
      },
    );
  }

  Widget _buildItem(IconData icon) {
    return AnimatedBuilder(
        animation: controller.items[index].animationController!,
        builder: (context, child) {
          final item = controller.items[index];
          final Offset animatedOffset =
              item.isAnimated ? calculateAnimatedOffset(item) : Offset.zero;
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
                animation: controller.hoverController.hoveredController,
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
