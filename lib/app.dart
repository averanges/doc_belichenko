import 'package:doc_belichenko/controllers/controller.dart';
import 'package:doc_belichenko/view/dock.dart';
import 'package:doc_belichenko/view/dock_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [Widget] building the [MaterialApp].
/// Contains the [Dock] widget and [DockItem].
/// Uses the [Controller] to manage the state of the [Dock] widget.
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
      body: Center(
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
    );
  }
}
