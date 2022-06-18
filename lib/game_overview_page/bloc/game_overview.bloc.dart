import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:decks_repository/decks_repository.dart';

part 'game_overview.event.dart';
part 'game_overview.state.dart';

class GameOverviewBloc extends Bloc<GameOverviewEvent, GameOverviewState> {
  GameOverviewBloc({
    required DecksRepository decksRepository,
    required Deck? initialDeck,
  })  : _decksRepository = decksRepository,
        super(
          GameOverviewState(
            initialDeck: initialDeck,
          ),
        ) {}

  final DecksRepository _decksRepository;
}
