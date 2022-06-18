import 'dart:async';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:forehead_guess/design/fg_design.dart';
import 'package:flutter/services.dart';
import 'package:forehead_guess/game_page/game.page.dart';
import 'package:forehead_guess/game_page/widgets/button_bar.dart';
import 'package:forehead_guess/game_page/widgets/card.dart';
import 'package:forehead_guess/game_page/widgets/close_button.dart';
import 'package:forehead_guess/util/colored_box.dart';
import 'package:forehead_guess/util/empty_placeholder.dart';
import 'package:forehead_guess/game_page/widgets/gyroskope_recogniser.dart';
import 'package:forehead_guess/game_page/widgets/timer.dart';
import 'package:forehead_guess/util/shared_prefs.dart';

import '../../util/constants.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decks_repository/decks_repository.dart';
import '../../design/fg_design.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  static Route<void> route({Deck? initialDeck}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => GameBloc(
          initialDeck: initialDeck,
        ),
        child: const GametView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const GametView();
  }
}

class GametView extends StatefulWidget {
  static final routeName = (GamePage).toString();

  const GametView({Key? key}) : super(key: key);

  @override
  State<GametView> createState() => _GameViewState();
}

class _GameViewState extends State<GametView> {
  AudioCache audioCache = AudioCache();
  Widget _wordWidget = FGCard(
    text: 'Test',
    key: UniqueKey(),
    color: fgDarkColor,
    sideColor: fgDarkColorLight,
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
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
            body: MultiBlocListener(
              listeners: [
                BlocListener<GameBloc, GameState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status,
                  listener: (context, state) {
                    if (state.status == GameStatus.success ||
                        state.status == GameStatus.ended) {
                      _wordWidget = FGCard(
                        key: UniqueKey(),
                        text: state.currentWord,
                        color: fgDarkColor,
                        sideColor: fgDarkColorLight,
                      );
                    } else if (state.status == GameStatus.incorrect) {
                      audioCache.play(Constant.incorrectAudioPath);

                      _wordWidget = FGCard(
                        key: UniqueKey(),
                        text: 'Wrong',
                        color: fgWarningColor,
                        sideColor: fgWarningColorLight,
                      );
                    } else if (state.status == GameStatus.correct) {
                      audioCache.play(Constant.correctAudioPath);
                      _wordWidget = FGCard(
                        key: UniqueKey(),
                        text: 'Right',
                        color: fgPrimaryColor,
                        sideColor: fgPrimaryColorLight,
                      );
                    } else {
                      _wordWidget = FGCard(
                        key: UniqueKey(),
                        text: 'Error',
                        color: fgWarningColor,
                        sideColor: fgWarningColorLight,
                      );
                    }
                  },
                )
              ],
              child: Stack(children: <Widget>[
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (widget, animation) => ScaleTransition(
                          scale: animation,
                          child: widget,
                        ),
                    child: BlocBuilder<GameBloc, GameState>(
                        builder: (context, state) {
                      if (state.status == GameStatus.loading) {
                        return const Center(
                            child: SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  color: fgBrightColor,
                                  strokeWidth: 5,
                                )));
                      } else if (state.status == GameStatus.success) {
                        return _wordWidget;
                      } else {
                        return const Center(
                          child: Text("error"),
                        );
                      }
                    })),
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
                                width:
                                    (MediaQuery.of(context).size.height * 0.3 -
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
            )));
  }
}
