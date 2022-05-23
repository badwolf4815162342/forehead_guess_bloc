import 'package:flutter/material.dart';
import '../../design/fg_design.dart';
import '../../util/constants.dart';

class FGCloseButton extends StatelessWidget {
  const FGCloseButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => {
              /**    SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]),*/
              Navigator.pop(context)
            },
        icon: const Icon(
          Icons.close,
          color: fgBoringColor,
          size: Constant.iconSize,
        ));
  }
}
