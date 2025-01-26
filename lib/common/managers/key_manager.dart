import 'package:flutter/material.dart';

///Manager for [GlobalKey]s.
class KeyManager {
  KeyManager._();

  static final KeyManager instance = KeyManager._();

  GlobalKey createGlobalKey() => GlobalKey();

  BuildContext? getContext(GlobalKey key) => key.currentContext;

  ///Returns the [RenderBox] of the given [GlobalKey].
  RenderBox? getRenderBox(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return null;
    return context.findRenderObject() as RenderBox;
  }
}
