import 'package:doc_belichenko/app.dart';
import 'package:doc_belichenko/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///Test app for Doc Belichenko
///Explanation of folder structure and files
///App separate in 4 folders
///1. controllers - [Controller], [DragInsideController], [DragOutsideController], [HoverController]
///2. models - [DragInfo], [ElementModel]
///3. view - [Dock], [DockItem]
///4. common
///[Controller] - handles the state of the application and all operations of this test app such as:
///swapping items in the list, dragging items outside the list, and hovering over items in the list
///[DragInsideController] - handles the drag-and-drop operations when items are dragged inside a target area.
///[DragOutsideController] - handles the drag-and-drop operations when items are dragged outside their original area.
///[HoverController] - handles the hover effects when items in the list are hovered over.
///Uinterface of the application is built using the following widgets:
///[Dock] - widget that builds the list of draggable items.
///[DockItem] - widget that represents each draggable item in the list.
///Build can be seen by this link:
///https://github.com/DocBelichenko/flutter_doc_belichenko

/// Entrypoint of the application.
void main() {
  Get.put<Controller>(Controller());
  runApp(const App());
}
