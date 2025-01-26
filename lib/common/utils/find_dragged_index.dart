import 'package:doc_belichenko/models/element_model.dart';

int? findDraggedIndex(List<ElementModel> items) {
  if (!items.any((e) => e.isDragged)) return null;
  return items.asMap().entries.firstWhere((e) => e.value.isDragged).key;
}
