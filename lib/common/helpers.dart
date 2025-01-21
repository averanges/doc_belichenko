import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/models/item_render_box_model.dart';
import 'package:flutter/material.dart';

//Simple general helper method to get data of [Render Box] using [Global Key]
ItemRenderBoxModel getRenderBoxDetails(GlobalKey key) {
  final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) {
    throw Exception("RenderBox not found for the provided GlobalKey.");
  }

  final globalPosition = renderBox.localToGlobal(Offset.zero);
  final size = renderBox.size;
  final center = globalPosition + Offset(size.width / 2, size.height / 2);
  final boundaries = {
    Direction.left: globalPosition.dx,
    Direction.top: globalPosition.dy,
    Direction.right: globalPosition.dx + size.width,
    Direction.bottom: globalPosition.dy + size.height,
  };

  return ItemRenderBoxModel(
    renderBox: renderBox,
    globalPosition: globalPosition,
    size: size,
    center: center,
    boundaries: boundaries,
  );
}

//Helper method to create new [AnimationController]
AnimationController createNewAnimationController(TickerProvider vsync) {
  return AnimationController(
    vsync: vsync,
    duration: const Duration(milliseconds: 200),
  );
}
