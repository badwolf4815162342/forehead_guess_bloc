import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forehead_guess/design/fg_button.dart';

import '../../main.dart';

class StartRoundButton extends ConsumerWidget {
  const StartRoundButton({
    Key? key,
    required this.onTab,
  }) : super(key: key);

  final void Function()? onTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String text = "Start Round";
    if (ref.watch(decksService).getResultWords().isNotEmpty) {
      text = "Start new Round";
    }
    return FGButton(
      onTap: onTab,
      title: text,
    );
  }
}
