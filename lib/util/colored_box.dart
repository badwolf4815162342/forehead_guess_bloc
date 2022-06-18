import 'package:flutter/material.dart';
import 'package:forehead_guess/ui/widgets/empty_placeholder.dart';

class FGColoredBox extends StatelessWidget {
  const FGColoredBox({
    required this.height,
    required this.width,
    required this.color,
    Key? key,
  }) : super(key: key);

  final double height;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        color: color,
        child: const EmptyPlaceholder());
  }
}
