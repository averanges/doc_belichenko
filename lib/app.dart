import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/controllers/controller.dart';
import 'package:doc_belichenko/view/dock.dart';
import 'package:doc_belichenko/view/dock_item.dart';
import 'package:doc_belichenko/view/positioned_drag_element.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Start point of the application.
///
/// Uses global [Stack] to handle case when user drags an element outside [Dock] and cancels the drag operation.
/// [PositionedEndDragElement] widget is visual fake [Draggable] that appears on the same position as the original [Draggable].
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _buildMaterialChild(),
    );
  }

  Widget _buildMaterialChild() {
    final Controller controller = Get.find<Controller>();
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Dock(
              items: controller.items,
              builder: (e) {
                return DockItem(
                  controller: controller,
                  icon: e.icon,
                  index: controller.items.indexOf(e),
                  key: e.key,
                  color: e.color,
                );
              },
            ),
          ),
          Obx(
            () => controller.isCanceled &&
                    controller.dragInfo?.currentDragState == DragState.outside
                ? PositionedEndDragElement(
                    controller: controller,
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}
