// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:forehead_guess/design/fg_colors.dart';
import 'package:forehead_guess/services/decks.service.dart';
import 'package:forehead_guess/ui/deck_edit.page.dart';
import 'package:forehead_guess/ui/game_settings.page.dart';

import 'package:forehead_guess/ui/decks.page.dart';
import 'package:forehead_guess/ui/game.page.dart';
import 'package:forehead_guess/ui/game_overview.page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forehead_guess/ui/game_start.page.dart';
import 'package:flutter/services.dart';
import 'package:forehead_guess/util/shared_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      const ProviderScope(child: MyApp()),
    );
  });
}

final decksService = ChangeNotifierProvider((ref) => DecksService());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: DecksPage.routeName,
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: fgPrimaryColor,
        // Define the default font family.
        fontFamily: 'Poppins',
      ),
      routes: {
        DecksPage.routeName: (context) => const DecksPage(),
        GamePage.routeName: (context) => const GamePage(),
        GameOverviewPage.routeName: (context) => const GameOverviewPage(),
        GameStartPage.routeName: (context) => const GameStartPage(),
        GameSettingsPage.routeName: (context) => const GameSettingsPage(),
        DeckEditPage.routeName: (context) => const DeckEditPage(),
      },
      title: 'Welcome to Flutter',
      home: const DecksPage(),
    );
  }
}
