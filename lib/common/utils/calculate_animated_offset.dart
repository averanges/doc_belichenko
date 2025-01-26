import 'package:doc_belichenko/common/managers/logger.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';

Offset calculateAnimatedOffset(ElementModel item) {
  if (item.renderBoxModel?.initialOffset == null ||
      item.renderBoxModel?.endOffset == null) {
    LoggerBase.e('Error with animatedOffset: item.renderBoxModel is null');
    return Offset.zero;
  }
  return Tween<Offset>(
    begin: Offset.zero,
    end: item.renderBoxModel!.endOffset - item.renderBoxModel!.initialOffset,
  ).animate(item.animationController!).value;
}
