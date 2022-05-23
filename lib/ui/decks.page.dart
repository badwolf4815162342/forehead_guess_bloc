import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forehead_guess/design/fg_design.dart';
import 'package:forehead_guess/ui/game_overview.page.dart';
import 'package:forehead_guess/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design/fg_design.dart';
import 'deck_edit.page.dart';
import 'game_settings.page.dart';
import 'widgets/deck_list_icon.dart';

class DecksPage extends ConsumerStatefulWidget {
  static final routeName = (DecksPage).toString();

  const DecksPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DecksPage> createState() => _DecksPageState();
}

class _DecksPageState extends ConsumerState<DecksPage> {
  final List<String> _decks = [];

  onPressedDeck(int index) {
    ref.read(decksService).setCurrentDeck(index);
    Navigator.pushNamed(context, GameOverviewPage.routeName);
  }

  openSettings(BuildContext context) {
    Navigator.pushNamed(context, GameSettingsPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: fgPrimaryColor,
          title: FGText.headingOne('Your Decks:'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: fgPrimaryColorLight,
              ),
              onPressed: () {
                ref.read(decksService).initialize();
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: fgPrimaryColorLight,
              ),
              onPressed: () {
                openSettings(context);
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.read(decksService).resetCurrentDeck();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const DeckEditPage(),
            ));
          },
          backgroundColor: fgBrightColor,
          child: const Icon(Icons.add),
        ),
        backgroundColor: fgDarkColor,
        body: Center(
          child: ref.watch(decksService).isLoading
              ? const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: fgBrightColor,
                    strokeWidth: 5,
                  ))
              : GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(
                      ref.watch(decksService).getDeckNames().length, (index) {
                    return DeckListIcon(
                        deck: ref.watch(decksService).decks[index],
                        index: index,
                        onPressedDeck: onPressedDeck);
                  }),
                ),
        ));
  }
}
