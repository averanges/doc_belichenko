import 'package:doc_belichenko/common/managers/key_manager.dart';
import 'package:doc_belichenko/models/item_render_box_model.dart';
import 'package:flutter/material.dart';

ItemRenderBoxModel createNewRenderBoxModelFromKey(GlobalKey key) =>
    ItemRenderBoxModel.fromRenderBox(KeyManager.instance.getRenderBox(key)!);
