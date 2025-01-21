import 'package:doc_belichenko/common/consts.dart';
import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/common/helpers.dart';
import 'package:doc_belichenko/controllers/drag_inside_controller.dart';
import 'package:doc_belichenko/controllers/drag_outside_controller.dart';
import 'package:doc_belichenko/controllers/hover_controller.dart';
import 'package:doc_belichenko/controllers/init_actions_controller.dart';
import 'package:doc_belichenko/models/drag_info.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Main Controller
//It contains 4 controllers: [HoverController], [DragOutsideController], [DragInsideController], [InitActionsController]
//First 3 controllers handling 3 types of actions in this test app
//It is responsible for managing drag-and-drop operations and hover effects
//and also used as provider for other controllers
class Controller extends GetxController with GetTickerProviderStateMixin {
  final RxList<ElementModel> _items = defaultElements.obs;

  List<ElementModel> get items => _items;

  Rx<DragInfo?> _dragInfo = Rx<DragInfo?>(null);

  DragInfo? get dragInfo => _dragInfo.value;

  final HoverController _hoveredController = HoverController();
  final DragOutsideController _dragOutsideController = DragOutsideController();
  final InitActionsController _initActionsController = InitActionsController();
  final DragInsideController _dragInsideController = DragInsideController();

  HoverController get hoveredController => _hoveredController;
  DragOutsideController get dragOutsideController => _dragOutsideController;
  DragInsideController get dragInsideController => _dragInsideController;

  void onDragStarted(int index) {
    _hoveredController.resetHoverEffects(items);
    _dragInfo = DragInfo(
      draggedIndex: index,
      currentDragState: DragState.inside,
      previousDragState: DragState.inside,
    ).obs;
    _items[index] = _items[index].copyWith(isDragged: true);
    _items.refresh();
  }

  void onDragUpdate(Offset mousePosition) {
    try {
      final newDragState =
          DragInfo.calculateDragState(AppConsts.containerKey, mousePosition);
      final previousDragState = _dragInfo.value?.currentDragState;
      _dragInfo.value = _dragInfo.value?.copyWith(
        currentDragState: newDragState,
        previousDragState: previousDragState,
      );
      if (_dragInfo.value?.previousDragState == DragState.outside &&
          _dragInfo.value?.currentDragState == DragState.inside) {
        _dragInfo.value =
            _dragInfo.value?.copyWith(isPlacedBetweenItemsActive: true);
        _dragOutsideController.placeDraggableBetweenItems(
            mousePosition, _items);
        _items.refresh();
      }
    } catch (e) {
      AppConsts.logger.e(e);
    } finally {
      _dragInfo.value =
          _dragInfo.value?.copyWith(isPlacedBetweenItemsActive: false);
    }
  }

  void onDragEnd() {
    final dragIndex = DragInfo.findDraggedIndex(_items);
    _items[dragIndex] = _items[dragIndex].copyWith(isDragged: false);
    _dragInfo = null.obs;
    if (_dragInsideController.functionQueue.isNotEmpty) {
      for (var element in _items) {
        element.animationController?.reset();
        element = element.copyWith(
            animationController: createNewAnimationController(this));
      }
      _items.refresh();
      _dragInsideController.isProcessingQueue = false;
      _dragInsideController.functionQueue.clear();
    }
  }

  void onSwapLeave() {
    _dragInsideController.onSwapLeave();
  }

  void onSwapStarted(Offset touchPosition, int targetIndex) {
    _dragInsideController.onSwapStarted(touchPosition, targetIndex, _items);
  }

  void onSwapUpdate({
    required Offset currentPosition,
    required int targetIndex,
  }) {
    final isPlacedBetweenItemsActive =
        _dragInfo.value?.isPlacedBetweenItemsActive;
    _dragInsideController.onSwapUpdate(
        currentPosition: currentPosition,
        targetIndex: targetIndex,
        ticker: this,
        items: _items,
        isPlacedBetweenItemsActive: isPlacedBetweenItemsActive ?? false);
  }

  @override
  void onInit() {
    super.onInit();
    _initActionsController.initializeItemsModels(items, this);
    _hoveredController.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initActionsController.calculateItemInitialOffsets(items);
    _initActionsController.calculateItemCenters(items);
  }

  @override
  void onClose() {
    super.onClose();
    _hoveredController.dispose();
  }
}
