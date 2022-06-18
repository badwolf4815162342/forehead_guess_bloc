import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:decks_repository/decks_repository.dart';

part 'deck_overview.event.dart';
part 'deck_overview.state.dart';

class DeckOverviewBloc extends Bloc<DeckOverviewEvent, DeckOverviewState> {
  DeckOverviewBloc({
    required DecksRepository decksRepository,
    required Deck? initialDeck,
  })  : _decksRepository = decksRepository,
        super(
          DeckOverviewState(
            initialDeck: initialDeck,
            name: initialDeck?.name ?? '',
            image: initialDeck?.image ?? '',
            words: initialDeck?.words.join(',') ?? '',
          ),
        ) {}

  final DecksRepository _decksRepository;
}
