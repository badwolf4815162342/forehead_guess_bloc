import 'package:flutter/material.dart';
import 'package:forehead_guess/design/fg_colors.dart';
import 'package:forehead_guess/design/fg_design.dart';
import 'package:forehead_guess/ui/deck_edit.page.dart';
import 'package:forehead_guess/ui/game_start.page.dart';
import 'package:flutter/services.dart';
import 'package:forehead_guess/ui/widgets/colored_box.dart';
import 'package:forehead_guess/ui/widgets/deck_image.dart';
import 'package:forehead_guess/ui/widgets/deck_name.dart';
import 'package:forehead_guess/ui/widgets/result_card.dart';
import 'package:forehead_guess/ui/widgets/start_round_button.dart';

import '../util/constants.dart';

class GameOverviewPage extends StatefulWidget {
  static final routeName = (GameOverviewPage).toString();
  const GameOverviewPage({Key? key}) : super(key: key);

  @override
  State<GameOverviewPage> createState() => _GameOverviewPageState();
}

class _GameOverviewPageState extends State<GameOverviewPage>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    ));
    controller.forward();
  }

  void onReInit() {
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void startGame() {
    Navigator.pushNamed(context, GameStartPage.routeName)
        .then((value) => onReInit());
  }

  _openDeckEdit(BuildContext context) {
    Navigator.pushNamed(context, DeckEditPage.routeName);
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
                  _openDeckEdit(context);
                },
              )
            ],
          ),
          backgroundColor: fgBrightColor,
          body: Stack(children: <Widget>[
            Positioned(
                top: 0.0,
                right: 0.0,
                left: 0.0,
                child: Padding(
                    padding: const EdgeInsets.all(Constant.paddingResultCard),
                    child: Column(children: <Widget>[
                      const DeckImage(),
                      StartRoundButton(onTab: startGame),
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
                        color: fgPrimaryColor, sideColor: fgPrimaryColorLight),
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
          ]),
        ));
  }
}
