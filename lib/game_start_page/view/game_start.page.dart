import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forehead_guess/design/fg_design.dart';
import 'package:forehead_guess/design/fg_styles.dart';
import 'package:forehead_guess/game_overview_page/bloc/game_overview.bloc.dart';
import 'package:forehead_guess/game_page/game.page.dart';
import 'package:forehead_guess/game_page/view/game.page.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:forehead_guess/game_start_page/bloc/game_start.bloc.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../util/constants.dart';

class GameStartPage extends StatelessWidget {
  const GameStartPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const GameStartView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const GameStartView();
  }
}

class GameStartView extends StatelessWidget {
  static final routeName = (GameStartPage).toString();

  const GameStartView({Key? key}) : super(key: key);

  _onWillPop(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final GameOverviewBloc _gameOverViewBloc =
        BlocProvider.of<GameOverviewBloc>(context);
    return WillPopScope(
        onWillPop: _onWillPop(context),
        child: Scaffold(
            backgroundColor: fgDarkColor,
            body: BlocBuilder<GameStartBloc, GameStartState>(
                builder: (context, state) {
              if (state.initialDeck == null) {
                if (state.status == GameStartStatus.loading) {
                  return const Center(
                      child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            color: fgBrightColor,
                            strokeWidth: 5,
                          )));
                } else if (state.status != GameStartStatus.success) {
                  return const SizedBox();
                } else {
                  return const Center(
                    child: Text("No Deck available"),
                  );
                }
              }

              return Center(
                  child: Padding(
                      padding: const EdgeInsets.all(Constant.paddingWordCard),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FGText.warningText(
                              'Turn your phone to horizontal, hold to your forehead and get ready ... ',
                              maxLines: 2,
                            ),
                            CircularCountDownTimer(
                                duration: 3,
                                fillColor: fgDarkColor,
                                height: 60,
                                width: 60,
                                textStyle: heading1Style.copyWith(
                                    color: fgWarningColor),
                                ringColor: fgPrimaryColor,
                                onComplete: () => {
                                      // TODO
                                      Navigator.of(context).push(GamePage.route(
                                          initialDeck: state.initialDeck!))
                                    }),
                          ])));
            })));
  }
}
