import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forehead_guess/decks_page/decks.page.dart';
import 'package:forehead_guess/design/fg_design.dart';
import 'package:decks_repository/decks_repository.dart';
import '../../design/fg_design.dart';
import '../../deck_edit_page/view/deck_edit.page.dart';
import '../../game_settings_page/view/game_settings.page.dart';
import 'package:forehead_guess/game_overview_page/view/game_overview.page.dart';

class DecksPage extends StatelessWidget {
  const DecksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DecksBloc(
        decksRepository: context.read<DecksRepository>(),
      )..add(const DecksOverviewSubscriptionRequested()),
      child: const DecksView(),
    );
  }
}

class DecksView extends StatelessWidget {
  const DecksView({Key? key}) : super(key: key);

  onPressedDeck(BuildContext context, Deck deck) {
    // ref.read(decksService).setCurrentDeck(index);
    // Navigator.pushNamed(context, GameOverviewPage.routeName);
    Navigator.of(context).push(
      GameOverviewPage.route(initialDeck: deck),
    );
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
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const DeckEditPage(),
            ));
            Navigator.of(context).push(
              DeckEditPage.route(initialDeck: deck),
            );
          },
          backgroundColor: fgBrightColor,
          child: const Icon(Icons.add),
        ),
        backgroundColor: fgDarkColor,
        body: MultiBlocListener(
          listeners: [
            BlocListener<DecksBloc, DecksState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == DecksStatus.failure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text("Decks are not loading ..."),
                      ),
                    );
                }
              },
            ),
            BlocListener<DecksBloc, DecksState>(
              listenWhen: (previous, current) =>
                  previous.lastDeletedDeck != current.lastDeletedDeck &&
                  current.lastDeletedDeck != null,
              listener: (context, state) {
                final deletedTodo = state.lastDeletedDeck!;
                final messenger = ScaffoldMessenger.of(context);
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text("Deck deleted"),
                      action: SnackBarAction(
                        label: "undo deletion",
                        onPressed: () {
                          messenger.hideCurrentSnackBar();
                          context
                              .read<DecksBloc>()
                              .add(const DecksOverviewUndoDeletionRequested());
                        },
                      ),
                    ),
                  );
              },
            ),
          ],
          child: BlocBuilder<DecksBloc, DecksState>(
            builder: (context, state) {
              if (state.decks.isEmpty) {
                if (state.status == DecksStatus.loading) {
                  return const Center(
                      child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            color: fgBrightColor,
                            strokeWidth: 5,
                          )));
                } else if (state.status != DecksStatus.success) {
                  return const SizedBox();
                } else {
                  return const Center(
                    child: Text("No Decks available"),
                  );
                }
              }
              return GridView.count(
                crossAxisCount: 2,
                children: List.generate(state.decks.length, (index) {
                  return DeckListIcon(
                    deck: state.decks[index],
                    index: index,
                    onPressedDeck: onPressedDeck(context, state.decks[index]),
// on  dissmissed
                  );
                }),
              );
            },
          ),
        ));
  }
}

                    /** onDismissed: (_) {
                        context
                            .read<TodosOverviewBloc>()
                            .add(TodosOverviewTodoDeleted(todo));
                      } */