import 'dart:async';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:forehead_guess/design/fg_design.dart';
import 'package:flutter/services.dart';
import 'package:forehead_guess/ui/widgets/button_bar.dart';
import 'package:forehead_guess/ui/widgets/card.dart';
import 'package:forehead_guess/ui/widgets/close_button.dart';
import 'package:forehead_guess/ui/widgets/colored_box.dart';
import 'package:forehead_guess/ui/widgets/empty_placeholder.dart';
import 'package:forehead_guess/ui/widgets/gyroskope_recogniser.dart';
import 'package:forehead_guess/ui/widgets/timer.dart';
import 'package:forehead_guess/util/shared_prefs.dart';

import '../util/constants.dart';

class GamePage extends StatefulWidget {
  static final routeName = (GamePage).toString();

  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  AudioCache audioCache = AudioCache();
  Widget _wordWidget = const FGCard(
    color: fgDarkColor,
    sideColor: fgDarkColorLight,
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    _wordWidget = FGCard(
      key: UniqueKey(),
      color: fgDarkColor,
      sideColor: fgDarkColorLight,
    );
  }

  void _displayResult(bool correct) {
    if (correct) {
      audioCache.play(Constant.correctAudioPath);
      setState(() {
        _wordWidget = FGCard(
          key: UniqueKey(),
          text: 'Right',
          color: fgPrimaryColor,
          sideColor: fgPrimaryColorLight,
        );
      });
    } else {
      audioCache.play(Constant.incorrectAudioPath);
      setState(() {
        _wordWidget = FGCard(
          key: UniqueKey(),
          text: 'Wrong',
          color: fgWarningColor,
          sideColor: fgWarningColorLight,
        );
      });
    }
    Timer(Duration(seconds: sharedPrefs.timerDurationInSeconds),
        () => {_flipNewCard()});
  }

  void _flipNewCard() {
    setState(() {
      _wordWidget = FGCard(
        key: UniqueKey(),
        color: fgDarkColor,
        sideColor: fgDarkColorLight,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<bool> _onWillPop() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return _onWillPop();
        },
        child: Scaffold(
          backgroundColor: fgBrightColor,
          body: Stack(children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (widget, animation) => ScaleTransition(
                scale: animation,
                child: widget,
              ),
              child: _wordWidget,
            ),
            Positioned(
                top: 0.0,
                right: 0.0,
                left: 0.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const <Widget>[
                      FGTimer(),
                    ])),
            Positioned(
                top: 0.0,
                right: 0.0,
                left: 0.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: (Constant.borderWidthSmall)),
                        child: FGColoredBox(
                            color: fgPrimaryColor,
                            height: Constant.borderWidthSmall,
                            width: (MediaQuery.of(context).size.height * 0.3 -
                                Constant.borderWidthSmall * 2)),
                      ),
                    ])),
            Positioned(
              top: 5.0,
              right: 5.0,
              child: FGGyroscopeRecogniser(onGuess: _displayResult),
            ),
            const Positioned(
              top: 0.0,
              left: 0.0,
              child: FGCloseButton(),
            ),
            sharedPrefs.debug
                ? Positioned(
                    bottom: 0, child: FGButtonBar(onGuess: _displayResult))
                : const EmptyPlaceholder(),
          ]),
        ));
  }
}
