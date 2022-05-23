import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forehead_guess/design/fg_design.dart';
import 'package:forehead_guess/design/fg_styles.dart';
import 'package:forehead_guess/ui/game.page.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import '../main.dart';
import '../util/constants.dart';

class GameStartPage extends ConsumerStatefulWidget {
  static final routeName = (GameStartPage).toString();

  const GameStartPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GameStartPage> createState() => _GameStartPageState();
}

class _GameStartPageState extends ConsumerState<GameStartPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future<bool> _onWillPop() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: fgDarkColor,
            body: Center(
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
                              textStyle:
                                  heading1Style.copyWith(color: fgWarningColor),
                              ringColor: fgPrimaryColor,
                              onComplete: () => {
                                    ref.read(decksService).resetGame(),
                                    Navigator.pushReplacementNamed(
                                        context, GamePage.routeName)
                                  }),
                        ])))));
  }
}
