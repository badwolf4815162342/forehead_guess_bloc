import 'package:flutter/material.dart';
import '../../design/fg_design.dart';
import '../../util/constants.dart';

class FGImageErrorPlaceholder extends StatelessWidget {
  const FGImageErrorPlaceholder({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: fgWarningColor,
      alignment: Alignment.center,
      child: Padding(
          padding: const EdgeInsets.all(Constant.borderRadiusSmall),
          child: FGText.unknownDeckName(text)),
    );
  }
}
