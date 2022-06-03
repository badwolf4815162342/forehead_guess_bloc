import 'package:flutter/material.dart';
import 'package:forehead_guess/util/shared_prefs.dart';
import 'package:settings_ui/settings_ui.dart';

import '../design/fg_design.dart';

class GameSettingsPage extends StatefulWidget {
  static final routeName = (GameSettingsPage).toString();

  const GameSettingsPage({Key? key}) : super(key: key);

  @override
  State<GameSettingsPage> createState() => _GameSettingsPageState();
}

class _GameSettingsPageState extends State<GameSettingsPage> {
  @override
  void initState() {
    super.initState();
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
                    value: SharedPrefs().timerDurationInSeconds.toString(),
                    icon: const Icon(Icons.timer),
                    elevation: 16,
                    style: const TextStyle(color: fgDarkColor),
                    underline: Container(
                      height: 5,
                      color: fgWarningColor,
                    ),
                    onChanged: (String? newValue) {
                      SharedPrefs().timerDurationInSeconds =
                          (int.parse(newValue!));
                      setState(() {});
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
                    value: SharedPrefs().gyroscopeSensitivity.toDouble(),
                    max: 4,
                    min: 2,
                    label: SharedPrefs().gyroscopeSensitivity.toString(),
                    onChanged: (double value) {
                      SharedPrefs().gyroscopeSensitivity = (value.toInt());
                      setState(() {});
                    },
                  )),
                  FGText.body(
                      'Show result card (Right/Wrong) for ${SharedPrefs().resultWaitSeconds.toString()} seconds',
                      maxLines: 2,
                      align: TextAlign.center),
                  CustomSettingsTile(
                      child: Slider(
                    activeColor: fgWarningColor,
                    inactiveColor: fgWarningColorLight,
                    value: SharedPrefs().resultWaitSeconds.toDouble(),
                    max: 4,
                    divisions: 1,
                    min: 1,
                    label: SharedPrefs().resultWaitSeconds.toString(),
                    onChanged: (double value) {
                      SharedPrefs().resultWaitSeconds = (value.toInt());
                      setState(() {});
                    },
                  )),
                  FGText.body(
                    'Wait ${SharedPrefs().resultWaitSecondsRoll.toString()} seconds after rolling your phone up/down until it again reacts to new rolling',
                    maxLines: 2,
                    align: TextAlign.center,
                  ),
                  CustomSettingsTile(
                      child: Slider(
                    activeColor: fgWarningColor,
                    inactiveColor: fgWarningColorLight,
                    value: SharedPrefs().resultWaitSecondsRoll.toDouble(),
                    max: 3,
                    min: 1,
                    label: SharedPrefs().resultWaitSecondsRoll.toString(),
                    onChanged: (double value) {
                      SharedPrefs().resultWaitSecondsRoll = (value.toInt());
                      setState(() {});
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
                      SharedPrefs().debug = value;
                      setState(() {});
                    },
                    initialValue: SharedPrefs().debug,
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
