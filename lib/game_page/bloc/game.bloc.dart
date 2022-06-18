import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:decks_repository/decks_repository.dart';
import "dart:math";
import 'dart:async';

import 'package:forehead_guess/util/shared_prefs.dart';
part 'game.event.dart';
part 'game.state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required Deck? initialDeck,
  }) : super(
          GameState(
            initialDeck: initialDeck,
            currentWord: '',
            resultWords: const {},
          ),
        ) {
    on<CorrectEvent>(_onCorrectInput);
    on<IncorrectEvent>(_onIncorrectInput);
    on<TimerEndedEvent>(_onTimerEnded);
  }

  void _onCorrectInput(
    CorrectEvent event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(status: GameStatus.correct));
    state.resultWords[state.currentWord] = true;
    Timer(
        Duration(seconds: sharedPrefs.timerDurationInSeconds),
        () => {
              _setNextRandomWord(),
            });
  }

  void _onIncorrectInput(
    IncorrectEvent event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(status: GameStatus.incorrect));
    state.resultWords[state.currentWord] = true;
    Timer(
        Duration(seconds: sharedPrefs.timerDurationInSeconds),
        () => {
              _setNextRandomWord(),
            });
  }

  void _setNextRandomWord() {
    // WAITX
    // WAITX
    if (state.resultWords.length == state.initialDeck!.words.length) {
      emit(
          state.copyWith(status: GameStatus.ended, currentWord: "Deck empty!"));
    } else {
      Set<String> set1 = Set.from(state.initialDeck!.words);
      Set<String> set2 = Set.from(state.resultWords.keys);
      List<String> wordsToChooseFrom =
          List.from(List.from(set1.difference(set2)));
      final _random = Random();
      String nextWord =
          wordsToChooseFrom[_random.nextInt(wordsToChooseFrom.length)];
      emit(state.copyWith(status: GameStatus.success, currentWord: nextWord));
    }
  }

  void _onTimerEnded(
    TimerEndedEvent event,
    Emitter<GameState> emit,
  ) {
    // TODO
    emit(state.copyWith(status: GameStatus.ended));
  }
}
