part of 'game.bloc.dart';

enum GameStatus {
  initial,
  loading,
  success,
  ended,
  failure,
  correct,
  incorrect
}

extension GameStatusX on GameStatus {
  bool get isLoadingOrSuccess => [
        GameStatus.loading,
        GameStatus.success,
      ].contains(this);
}

class GameState extends Equatable {
  GameState({
    this.status = GameStatus.initial,
    this.initialDeck,
    this.currentWord = '',
    this.resultWords = const {},
  });

  final GameStatus status;
  final Deck? initialDeck;
  String currentWord;
  Map<String, bool> resultWords;

  GameState copyWith({
    required GameStatus status,
    Deck? initialDeck,
    String? currentWord,
    Map<String, bool>? resultWords,
  }) {
    return GameState(
      status: this.status,
      initialDeck: initialDeck ?? this.initialDeck,
      currentWord: currentWord ?? this.currentWord,
      resultWords: resultWords ?? this.resultWords,
    );
  }

  @override
  List<Object?> get props => [status, initialDeck, currentWord, resultWords];
}
