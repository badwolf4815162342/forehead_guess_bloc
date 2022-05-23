import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../design/fg_design.dart';
import '../../util/constants.dart';
import 'package:flutter/services.dart';

class FGTimer extends StatefulWidget {
  const FGTimer({
    Key? key,
  }) : super(key: key);

  @override
  State<FGTimer> createState() => _FGTimerState();
}

class _FGTimerState extends State<FGTimer> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _timerDurationInSeconds;

  @override
  void initState() {
    super.initState();
    _timerDurationInSeconds = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt(Constant.timerDurationInSecondsString) ??
          Constant.timerDurationInSecondsInitialValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    AudioCache audioCache = AudioCache();

    return FutureBuilder<int>(
        future: _timerDurationInSeconds,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Container(
                    width: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                        color: fgPrimaryColor,
                        border: Border.all(
                          color: fgPrimaryColorLight,
                          width: Constant.borderWidthSmall,
                        ),
                        borderRadius: const BorderRadius.only(
                            bottomLeft:
                                Radius.circular(Constant.borderRadiusSmall),
                            bottomRight:
                                Radius.circular(Constant.borderRadiusSmall))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TweenAnimationBuilder<Duration>(
                              duration: Duration(seconds: snapshot.data!),
                              tween: Tween(
                                  begin: Duration(seconds: snapshot.data!),
                                  end: Duration.zero),
                              onEnd: () {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                ]);
                                audioCache.play(Constant.timeUpAudioPath);

                                Navigator.pop(context);
                              },
                              builder: (BuildContext context, Duration value,
                                  Widget? child) {
                                final minutes = value.inMinutes;
                                final seconds = value.inSeconds % 60;
                                return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 2),
                                    child: FGText.timerStyle(
                                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                    ));
                              }),
                        ]));
              }
          }
        });
  }
}
