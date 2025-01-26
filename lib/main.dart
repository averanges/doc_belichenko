import 'package:doc_belichenko/app.dart';
import 'package:doc_belichenko/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///Test app for Doc Belichenko
///
///Uses GetX for state management using [Controller].
///Implement 3 main drag actions:
///Hover - [HoverController]
///Drag outside / input element - [DragOutsideController]
///Drag inside/ Swap elements - [DragInsideController]

void main() {
  Get.put<Controller>(Controller());
  runApp(const App());
}
