import 'package:doc_belichenko/common/consts.dart';
import 'package:doc_belichenko/common/enums.dart';
import 'package:doc_belichenko/common/managers/animation_manager.dart';
import 'package:doc_belichenko/common/managers/logger.dart';
import 'package:doc_belichenko/common/utils/find_dragged_index.dart';
import 'package:doc_belichenko/controllers/drag_inside_controller.dart';
import 'package:doc_belichenko/controllers/drag_outside_controller.dart';
import 'package:doc_belichenko/controllers/hover_controller.dart';
import 'package:doc_belichenko/controllers/init_actions_controller.dart';
import 'package:doc_belichenko/models/drag_info.dart';
import 'package:doc_belichenko/models/element_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///Main [GetxController] for managing state of the [Dock], [DockItem], [PositionedDragElement], [IconItem] widgets.
///
///All access to the ui happens through this controller.
///Handle all 3 main drag actions:
///Hover - [HoverController]
///Drag outside / input element - [DragOutsideController]
///Drag inside/ Swap elements - [DragInsideController]

class Controller extends GetxController {
  final RxList<ElementModel> _items = defaultElements.obs;
  final Rx<DragInfo?> _dragInfo = Rx<DragInfo?>(null);
  final RxBool _isCanceled = false.obs;

  final GlobalKey _containerKey = GlobalKey();

  final HoverController _hoverController = HoverController();
  final DragOutsideController _dragOutsideController = DragOutsideController();
  final DragInsideController _dragInsideController = DragInsideController();
  final InitActionsController _initActionsController = InitActionsController();
  final AnimationManager _animationManager = AnimationManager.instance;

  List<ElementModel> get items => _items;
  DragInfo? get dragInfo => _dragInfo.value;
  bool get isCanceled => _isCanceled.value;
  GlobalKey get containerKey => _containerKey;
  HoverController get hoverController => _hoverController;
  AnimationManager get animationManager => _animationManager;

  @override
  void onInit() {
    super.onInit();
    _initActionsController.initializeItemsModels(items);
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initActionsController.calculateItemInitialOffsets(items);
    });
  }

  @override
  void onClose() {
    _animationManager.dispose();
    super.onClose();
  }

  void onDragStarted(int index) {
    _resetHoverEffects();
    _startNewDrag(index);
  }

  void onDragUpdate(Offset mousePosition) {
    try {
      _updateDragInfo(mousePosition);
    } catch (e) {
      LoggerBase.e(e);
    } finally {
      _resetPlacementState();
    }
  }

  Future<void> onDragEnd() async {
    _dragInsideController.clearQueueOutside();
    _isCanceled.value = true;

    await Future.delayed(AppConsts.animationDuration);

    _finalizeDrag();
    _isCanceled.value = false;
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
    if (dragInfo?.isPlacedBetweenItemsActive == true) return;

    _dragInsideController.onSwapUpdate(
      currentPosition: currentPosition,
      targetIndex: targetIndex,
      items: _items,
    );
    _updateDraggedIndex();
  }

  void _resetHoverEffects() {
    _hoverController.resetHoverEffects(items);
  }

  void _startNewDrag(int index) {
    _dragInfo.value = DragInfo.createNewDragInfo(index, _items[index]);
    ElementModel.updateElementModelFromList(items, index, isDragged: true);
    _items.refresh();
  }

  void _updateDragInfo(Offset mousePosition) {
    final newDragState =
        DragInfo.calculateDragState(_containerKey, mousePosition);
    final previousDragState = _dragInfo.value?.currentDragState;

    _dragInfo.value = _dragInfo.value?.copyWith(
      endDragPosition: mousePosition,
      currentDragState: newDragState,
      previousDragState: previousDragState,
    );

    if (previousDragState == DragState.outside &&
        newDragState == DragState.inside) {
      _dragInfo.value =
          _dragInfo.value?.copyWith(isPlacedBetweenItemsActive: true);
      _dragOutsideController.placeDraggableBetweenItems(
        mousePosition,
        _items,
        _containerKey,
      );
      _items.refresh();
    }
  }

  void _resetPlacementState() {
    _dragInfo.value =
        _dragInfo.value?.copyWith(isPlacedBetweenItemsActive: false);
  }

  void _finalizeDrag() {
    final dragIndex = findDraggedIndex(items);
    if (dragIndex == null) return;

    _items[dragIndex] = _items[dragIndex].copyWith(isDragged: false);
    for (int i = 0; i < items.length; i++) {
      ElementModel.updateElementModelFromList(
        items,
        i,
        animationController: null,
      );
    }

    _dragInfo.value = null;
  }

  void _updateDraggedIndex() {
    _dragInfo.value = _dragInfo.value?.copyWith(
      draggedIndex: findDraggedIndex(items),
    );
    _dragInfo.refresh();
    _items.refresh();
  }
}
