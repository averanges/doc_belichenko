import 'package:doc_belichenko/common/consts.dart';
import 'package:doc_belichenko/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Dock of the reorderable [items].
class Dock<T> extends StatelessWidget {
  Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  final Controller _controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      onHover: (event) =>
          _controller.hoverController.onHover(event, _controller.items),
      onExit: (event) => _controller.hoverController.resetHoverEffects(
        _controller.items,
      ),
      child: Container(
        key: _controller.containerKey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConsts.itemBorderRadius),
          color: AppConsts.containerColor,
        ),
        padding: const EdgeInsets.all(AppConsts.padding),
        child: Obx(() {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: _controller.items.map((e) => builder(e as T)).toList(),
          );
        }),
      ),
    );
  }
}
