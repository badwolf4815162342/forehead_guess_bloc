import 'package:flutter/material.dart';
import 'package:forehead_guess/design/fg_colors.dart';
import 'package:forehead_guess/design/fg_design.dart';
import 'package:forehead_guess/deck_edit_page/view/deck_edit.page.dart';
import 'package:forehead_guess/game_overview_page/bloc/game_overview.bloc.dart';
import 'package:forehead_guess/game_start_page/view/game_start.page.dart';
import 'package:flutter/services.dart';
import 'package:forehead_guess/ui/widgets/colored_box.dart';
import 'package:forehead_guess/ui/widgets/deck_image.dart';
import 'package:forehead_guess/ui/widgets/deck_name.dart';
import 'package:forehead_guess/ui/widgets/result_card.dart';
import 'package:forehead_guess/ui/widgets/start_round_button.dart';

import '../../util/constants.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decks_repository/decks_repository.dart';
import '../../design/fg_design.dart';
import '../../deck_edit_page/view/deck_edit.page.dart';

class GameOverviewPage extends StatelessWidget {
  const GameOverviewPage({Key? key}) : super(key: key);

  static Route<void> route({Deck? initialDeck}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => GameOverviewBloc(
          decksRepository: context.read<DecksRepository>(),
          initialDeck: initialDeck,
        ),
        child: const GameOverviewView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const GameOverviewView();
  }
}

class GameOverviewView extends StatefulWidget {
  //static final routeName = (GameOverviewPage).toString();
  const GameOverviewView({Key? key}) : super(key: key);

  @override
  State<GameOverviewView> createState() => _GameOverviewViewState();
}

class _GameOverviewViewState extends State<GameOverviewView>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    ));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _startGame(Deck deck) {
    Navigator.of(context).push(
      GameStartPage.route(initialDeck: deck),
    );
  }

  _openDeckEdit(BuildContext context, Deck deck) {
    Navigator.of(context).push(
      DeckEditPage.route(initialDeck: deck),
    );
  }

  Future<bool> _onWillPop() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    controller.forward();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: fgPrimaryColor,
            title: const DeckName(),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: fgPrimaryColorLight,
                ),
                onPressed: () {
                  _openDeckEdit(context, state.initialDeck);
                },
              )
            ],
          ),
          backgroundColor: fgBrightColor,
          body: BlocBuilder<GameOverviewBloc, GameOverviewState>(
            builder: (context, state) {
              if (state.initialDeck == null) {
                if (state.status == GameOverviewStatus.loading) {
                  return const Center(
                      child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            color: fgBrightColor,
                            strokeWidth: 5,
                          )));
                } else if (state.status != GameOverviewStatus.success) {
                  return const SizedBox();
                } else {
                  return const Center(
                    child: Text("No Deck available"),
                  );
                }
              }
              return Stack(children: <Widget>[
                Positioned(
                    top: 0.0,
                    right: 0.0,
                    left: 0.0,
                    child: Padding(
                        padding:
                            const EdgeInsets.all(Constant.paddingResultCard),
                        child: Column(children: <Widget>[
                          const DeckImage(),
                          StartRoundButton(
                              onTab: _startGame(state.initialDeck!)),
                        ]))),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: SlideTransition(
                      position: animation,
                      child: const Padding(
                        padding: EdgeInsets.all(0),
                        child: FGResultCard(
                            color: fgPrimaryColor,
                            sideColor: fgPrimaryColorLight),
                      )),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: SlideTransition(
                      position: animation,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: (Constant.borderWidthBig +
                                Constant.paddingResultCard)),
                        child: FGColoredBox(
                            color: fgPrimaryColor,
                            height: Constant.borderWidthBig,
                            width: double.infinity),
                      )),
                ),
              ]);
            },
          ),
        ));
  }
}
