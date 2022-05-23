import 'package:flutter/material.dart';
import 'package:forehead_guess/ui/game_overview.page.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:forehead_guess/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../../design/fg_design.dart';

class FGButtonBar extends ConsumerWidget {
  const FGButtonBar({Key? key, required this.onGuess}) : super(key: key);

  final Function onGuess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        color: fgDarkColor,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FGButton(
                onTap: () => {
                  if (!ref.read(decksService).gameEnded)
                    {
                      ref.read(decksService).saveWordAndSetNewRandom(true),
                      onGuess(true)
                    }
                },
                title: 'Correct',
              ),
              FGButton(
                title: 'Incorrect',
                onTap: () => {
                  if (!ref.read(decksService).gameEnded)
                    {
                      ref.read(decksService).saveWordAndSetNewRandom(false),
                      onGuess(false)
                    }
                },
              ),
              Text('😊: ${ref.watch(decksService).getWordCountCorrect()}'),
              Text('🙁: ${ref.watch(decksService).getWordCountIncorrect()}'),
            ]));
  }
}
