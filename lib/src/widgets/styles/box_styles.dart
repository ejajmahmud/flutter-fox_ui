import 'package:mix/mix.dart';
import 'package:flutter/material.dart' as material;

BoxStyler _cardStyle(material.ThemeData theme) {
  return BoxStyler()
      .color(theme.cardColor)
      .margin(EdgeInsetsGeometryMix.all(4))
      .borderRadius(BorderRadiusGeometryMix.circular(8))
      .border(
        BoxBorderMix.all(BorderSideMix(color: theme.dividerColor, width: 1)),
      )
      .clipBehavior(material.Clip.antiAlias);
}
