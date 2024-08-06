import 'package:flutter/widgets.dart';

class CustomText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;

  const CustomText(this.data, {super.key, this.textAlign = TextAlign.start, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      style: style?.copyWith(fontSize: style?.fontSize ?? 24) ?? const TextStyle(fontSize: 24),
    );
  }
}
