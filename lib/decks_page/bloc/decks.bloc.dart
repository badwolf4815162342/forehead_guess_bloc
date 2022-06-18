import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:decks_repository/decks_repository.dart';

part 'decks.event.dart';
part 'decks.state.dart';

class DecksBloc extends Bloc<DecksEvent, DecksState> {
  DecksBloc({
    required DecksRepository decksRepository,
  })  : _decksRepository = decksRepository,
        super(const DecksState()) {
    on<DecksOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<DecksOverviewDeckDeleted>(_onDeckDeleted);
    on<DecksOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
  }

  final DecksRepository _decksRepository;

  Future<void> _onSubscriptionRequested(
    DecksOverviewSubscriptionRequested event,
    Emitter<DecksState> emit,
  ) async {
    emit(state.copyWith(status: () => DecksStatus.loading));

    await emit.forEach<List<Deck>>(
      _decksRepository.getDecks(),
      onData: (decks) => state.copyWith(
        status: () => DecksStatus.success,
        decks: () => decks,
      ),
      onError: (_, __) => state.copyWith(
        status: () => DecksStatus.failure,
      ),
    );
  }

  Future<void> _onDeckDeleted(
    DecksOverviewDeckDeleted event,
    Emitter<DecksState> emit,
  ) async {
    emit(state.copyWith(lastDeletedDeck: () => event.deck));
    await _decksRepository.deleteDeck(event.deck.filename);
  }

  Future<void> _onUndoDeletionRequested(
    DecksOverviewUndoDeletionRequested event,
    Emitter<DecksState> emit,
  ) async {
    assert(
      state.lastDeletedDeck != null,
      'Last deleted deck can not be null.',
    );

    final deck = state.lastDeletedDeck!;
    emit(state.copyWith(lastDeletedDeck: () => null));
    await _decksRepository.saveDeck(deck);
  }
}
