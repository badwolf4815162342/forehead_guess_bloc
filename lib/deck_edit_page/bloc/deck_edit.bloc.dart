import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:decks_repository/decks_repository.dart';

part 'deck_edit.event.dart';
part 'deck_edit.state.dart';

class EditTodoBloc extends Bloc<DeckEditEvent, DeckEditState> {
  EditTodoBloc({
    required DecksRepository decksRepository,
    required Deck? initialDeck,
  })  : _decksRepository = decksRepository,
        super(
          DeckEditState(
            initialDeck: initialDeck,
            name: initialDeck?.name ?? '',
            image: initialDeck?.image ?? '',
            words: initialDeck?.words.join(',') ?? '',
          ),
        ) {
    on<DeckEditNameChanged>(_onNameChanged);
    on<DeckEditImageChanged>(_onDescriptionChanged);
    on<DeckEditWordsChanged>(_onWordsChanged);
    on<DeckEditSubmitted>(_onSubmitted);
  }

  final DecksRepository _decksRepository;

  void _onNameChanged(
    DeckEditNameChanged event,
    Emitter<DeckEditState> emit,
  ) {
    emit(state.copyWith(title: event.name));
  }

  void _onDescriptionChanged(
    DeckEditImageChanged event,
    Emitter<DeckEditState> emit,
  ) {
    emit(state.copyWith(description: event.image));
  }

  void _onWordsChanged(
    DeckEditWordsChanged event,
    Emitter<DeckEditState> emit,
  ) {
    emit(state.copyWith(description: event.words));
  }

  Future<void> _onSubmitted(
    DeckEditSubmitted event,
    Emitter<DeckEditState> emit,
  ) async {
    emit(state.copyWith(status: DeckEditStatus.loading));
    String newFilename = state.initialDeck?.filename ?? '';
    if (newFilename == '') {
      newFilename = state.name.replaceAll(' ', '_') + '.json';
    }
    List<String> wordsList = [];
    state.words.toString().split(',').forEach((element) {
      wordsList.add(element.trim());
    });
    wordsList.removeWhere((v) => v == '');
    final deck = (state.initialDeck ??
            Deck(filename: newFilename, name: '', image: '', words: []))
        .copyWith(
      name: state.name,
      image: state.image,
      words: wordsList,
    );

    try {
      await _decksRepository.saveDeck(deck);
      emit(state.copyWith(status: DeckEditStatus.success));
    } catch (e) {
      emit(state.copyWith(status: DeckEditStatus.failure));
    }
  }
}
