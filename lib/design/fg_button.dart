import 'package:flutter/material.dart';

import '../util/constants.dart';
import 'fg_design.dart';

class FGButton extends StatelessWidget {
  final String title;
  final bool disabled;
  final bool busy;
  final void Function()? onTap;
  final bool outline;
  final Widget? leading;
  final Color color;

  const FGButton({
    Key? key,
    required this.title,
    this.disabled = false,
    this.busy = false,
    required this.onTap,
    this.leading,
    this.color = fgBoringColor,
  })  : outline = false,
        super(key: key);

  const FGButton.outline({
    required this.title,
    required this.onTap,
    this.leading,
  })  : disabled = false,
        busy = false,
        outline = true,
        color = fgGreyColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 300,
        height: 48,
        alignment: Alignment.center,
        decoration: !outline
            ? BoxDecoration(
                color: !disabled ? fgBoringColor : fgBoringColorLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: Constant.borderWidthSmall,
                    color: fgBoringColorLight))
            : BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: fgPrimaryColor,
                  width: 1,
                )),
        child: !busy
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) leading!,
                  if (leading != null) const SizedBox(width: 5),
                  FGText.bodyPrimary(title),
                ],
              )
            : const CircularProgressIndicator(
                strokeWidth: 8,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
      ),
    );
  }
}
