import 'package:doc_belichenko/common/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///Manager for [AnimationController] using centrilized [TickerProvider].
///
///There are 3 types of [AnimationController] : [hoverController],
///[positionController] for [PositionedDragElement] and [AnimationController]
///for every [ElementModel].
class AnimationManager extends TickerProvider {
  AnimationManager._();

  static AnimationManager instance = AnimationManager._();

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }

  late final AnimationController _hoverController =
      createNewAnimationController();

  AnimationController get hoverController => _hoverController;

  Animation<Offset> createPositionAnimation({
    required AnimationController controller,
    required Offset end,
  }) =>
      Tween<Offset>(
        begin: Offset.zero,
        end: end,
      ).animate(controller);

  Animation<double> createHoverAnimation({
    required double begin,
    required double end,
    required Curve curve,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: hoverController,
        curve: curve,
      ),
    );
  }

  void dispose() {
    hoverController.dispose();
  }

  AnimationController createNewAnimationController() {
    return AnimationController(
      vsync: this,
      duration: AppConsts.animationDuration,
    );
  }
}
