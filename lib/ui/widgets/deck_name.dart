import 'package:flutter/material.dart';
import 'package:forehead_guess/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design/fg_design.dart';

class DeckName extends ConsumerWidget {
  const DeckName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FGText.headingOne(ref.read(decksService).currentDeck.name);
  }
}
