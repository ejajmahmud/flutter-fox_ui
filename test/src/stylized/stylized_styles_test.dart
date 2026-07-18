import 'package:flutter_test/flutter_test.dart';
import 'package:fox_ui/fox_ui.dart';

void main() {
  test('stylized style aliases expose Mix stylers', () {
    expect(SBoxStyle(), isA<BoxStyler>());
    expect(SFlexBoxStyle(), isA<FlexBoxStyler>());
    expect(SRowBoxStyle.spacing(8), isA<FlexBoxStyler>());
    expect(SColumnBoxStyle.spacing(8), isA<FlexBoxStyler>());
    expect(STextStyle().fontSize(14), isA<TextStyler>());
    expect(SIconStyle(size: 16), isA<IconStyler>());
    expect(SImageStyle(width: 24), isA<ImageStyler>());
    expect(SPressableStyle(), isA<BoxStyler>());
    expect(SStackStyle(), isA<StackBoxStyler>());
  });
}
