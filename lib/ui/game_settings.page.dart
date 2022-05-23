import 'package:flutter/material.dart';
import 'package:forehead_guess/util/constants.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../design/fg_design.dart';

class GameSettingsPage extends StatefulWidget {
  static final routeName = (GameSettingsPage).toString();

  const GameSettingsPage({Key? key}) : super(key: key);

  @override
  State<GameSettingsPage> createState() => _GameSettingsPageState();
}

class _GameSettingsPageState extends State<GameSettingsPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _debug = Constant.debugInitialValue;
  int _timerDurationInSeconds = Constant.timerDurationInSecondsInitialValue;
  int _resultWaitSeconds = Constant.resultWaitSecondsInitialValue;
  int _resultWaitSecondsRoll = Constant.resultWaitSecondsRollInitialValue;
  int _gyroscopeSensitivity = Constant.gyroscopeSensitivityInitialValue;

  @override
  void initState() {
    super.initState();
    _loadSharedPrefs();
  }

  Future<void> _loadSharedPrefs() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _debug =
          (prefs.getBool(Constant.debugString) ?? Constant.debugInitialValue);
      _timerDurationInSeconds =
          (prefs.getInt(Constant.timerDurationInSecondsString) ??
              Constant.timerDurationInSecondsInitialValue);
      _resultWaitSeconds = (prefs.getInt(Constant.resultWaitSecondsString) ??
          Constant.resultWaitSecondsInitialValue);
      _resultWaitSecondsRoll =
          (prefs.getInt(Constant.resultWaitSecondsRollString) ??
              Constant.resultWaitSecondsRollInitialValue);
      _gyroscopeSensitivity =
          (prefs.getInt(Constant.gyroscopeSensitivityString) ??
              Constant.gyroscopeSensitivityInitialValue);
    });
  }

  Future<void> _setDebug(bool value) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setBool(Constant.debugString, value);
      _debug = value;
    });
  }

  Future<void> _setResultWaitSeconds(int value) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setInt(Constant.resultWaitSecondsString, value);
      _resultWaitSeconds = value;
    });
  }

  Future<void> _setGyroscopeSensitivity(int value) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setInt(Constant.gyroscopeSensitivityString, value);
      _gyroscopeSensitivity = value;
    });
  }

  Future<void> _setTimerDurationInSeconds(int value) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setInt(Constant.timerDurationInSecondsString, value);
      _timerDurationInSeconds = value;
    });
  }

  Future<void> _setResultWaitSecondsRoll(int value) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setInt(Constant.resultWaitSecondsRollString, value);
      _resultWaitSecondsRoll = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: fgPrimaryColor,
          title: FGText.headingOne('Settings'),
        ),
        backgroundColor: fgPrimaryColorLight,
        body: Center(
          child: SettingsList(
            sections: [
              CustomSettingsSection(
                  child: Column(
                children: [
                  FGText.body('Game Timer'),
                  DropdownButton<String>(
                    value: _timerDurationInSeconds.toString(),
                    icon: const Icon(Icons.timer),
                    elevation: 16,
                    style: const TextStyle(color: fgDarkColor),
                    underline: Container(
                      height: 5,
                      color: fgWarningColor,
                    ),
                    onChanged: (String? newValue) {
                      _setTimerDurationInSeconds(int.parse(newValue!));
                    },
                    items: <String>['30', '60', '90', '120', '180']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  FGText.body(
                      'Gyroscope Sensitivity (higher is less sensitive)'),
                  CustomSettingsTile(
                      child: Slider(
                    activeColor: fgWarningColor,
                    inactiveColor: fgWarningColorLight,
                    value: _gyroscopeSensitivity.toDouble(),
                    max: 4,
                    min: 2,
                    label: _gyroscopeSensitivity.toString(),
                    onChanged: (double value) {
                      _setGyroscopeSensitivity(value.toInt());
                    },
                  )),
                  FGText.body(
                      'Show result card (Right/Wrong) for ${_resultWaitSeconds.toString()} seconds',
                      maxLines: 2,
                      align: TextAlign.center),
                  CustomSettingsTile(
                      child: Slider(
                    activeColor: fgWarningColor,
                    inactiveColor: fgWarningColorLight,
                    value: _resultWaitSeconds.toDouble(),
                    max: 4,
                    divisions: 1,
                    min: 1,
                    label: _resultWaitSeconds.toString(),
                    onChanged: (double value) {
                      _setResultWaitSeconds(value.toInt());
                    },
                  )),
                  FGText.body(
                    'Wait ${_resultWaitSecondsRoll.toString()} seconds after rolling your phone up/down until it again reacts to new rolling',
                    maxLines: 2,
                    align: TextAlign.center,
                  ),
                  CustomSettingsTile(
                      child: Slider(
                    activeColor: fgWarningColor,
                    inactiveColor: fgWarningColorLight,
                    value: _resultWaitSecondsRoll.toDouble(),
                    max: 3,
                    min: 1,
                    label: _resultWaitSecondsRoll.toString(),
                    onChanged: (double value) {
                      _setResultWaitSecondsRoll(value.toInt());
                    },
                  )),
                ],
              )),
              SettingsSection(
                title: FGText.body('Developer Settings'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    activeSwitchColor: fgWarningColor,
                    onToggle: (value) {
                      _setDebug(value);
                    },
                    initialValue: _debug,
                    leading: const Icon(Icons.developer_mode),
                    title: FGText.body('Debug'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
