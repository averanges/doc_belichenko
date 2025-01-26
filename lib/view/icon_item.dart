import 'package:doc_belichenko/common/consts.dart';
import 'package:flutter/material.dart';

///[Widget] that displays an icon within a container.
class IconItem extends StatelessWidget {
  const IconItem({
    super.key,
    required this.icon,
    required this.color,
  });
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConsts.itemWidth,
      height: AppConsts.itemHeight,
      margin: const EdgeInsets.all(AppConsts.itemSpacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConsts.itemBorderRadius),
        color: color,
      ),
      child: Center(child: Icon(icon, color: AppConsts.iconColor)),
    );
  }
}
