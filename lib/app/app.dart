import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:forehead_guess/decks_page/decks.page.dart';

import '../design/fg_design.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.decksRepository}) : super(key: key);

  final DecksRepository decksRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: decksRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

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
      home: const DecksPage(),
    );
  }
}
