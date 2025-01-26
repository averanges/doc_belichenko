import 'package:doc_belichenko/common/managers/animation_manager.dart';
import 'package:doc_belichenko/common/managers/key_manager.dart';
import 'package:doc_belichenko/common/utils/create_new_render_box_model_from_key.dart';
import 'package:doc_belichenko/models/element_model.dart';

///Initialize items models, calculate initial offsets and centers.
class InitActionsController {
  void initializeItemsModels(List<ElementModel> items) {
    for (int i = 0; i < items.length; i++) {
      ElementModel.updateElementModelFromList(items, i,
          key: KeyManager.instance.createGlobalKey(),
          animationController:
              AnimationManager.instance.createNewAnimationController());
    }
  }

  void calculateItemInitialOffsets(List<ElementModel> items) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].key != null) {
        ElementModel.updateElementModelFromList(items, i,
            renderBoxModel: createNewRenderBoxModelFromKey(items[i].key!));
      }
    }
  }
}
