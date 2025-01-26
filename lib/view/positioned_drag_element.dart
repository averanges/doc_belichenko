import 'package:doc_belichenko/common/utils/find_dragged_index.dart';
import 'package:doc_belichenko/controllers/controller.dart';
import 'package:doc_belichenko/view/icon_item.dart';
import 'package:flutter/material.dart';

/// [Widget] that appears on the same position as the original [Draggable] when the user stops dragging.
///
/// Calculates the position based on the last position of the mouse pointer when the [Draggable] is released.
///And translate the widget to initial [Draggable] position.
///After that the widget is removed from the widget tree.
class PositionedEndDragElement extends StatefulWidget {
  const PositionedEndDragElement({
    super.key,
    required this.controller,
  });

  final Controller controller;

  @override
  State<PositionedEndDragElement> createState() =>
      _PositionedEndDragElementState();
}

class _PositionedEndDragElementState extends State<PositionedEndDragElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    final end = widget
            .controller
            .items[findDraggedIndex(widget.controller.items)!]
            .renderBoxModel!
            .initialOffset -
        (widget.controller.dragInfo?.endDragPosition ?? Offset.zero);
    _animationController =
        widget.controller.animationManager.createNewAnimationController();
    _animation = widget.controller.animationManager.createPositionAnimation(
      controller: _animationController,
      end: end,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.dragInfo == null) return const SizedBox();
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Positioned(
            top: widget.controller.dragInfo!.endDragPosition!.dy,
            left: widget.controller.dragInfo!.endDragPosition!.dx,
            child: Transform.translate(
              offset: _animation.value,
              child: IconItem(
                  icon: widget.controller.dragInfo!.element!.icon,
                  color: widget.controller.dragInfo!.element!.color),
            ),
          );
        });
  }
}
