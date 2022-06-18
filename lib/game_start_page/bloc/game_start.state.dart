part of 'game_start.bloc.dart';

enum GameStartStatus { initial, loading, success, failure }

class GameStartState extends Equatable {
  const GameStartState({
    this.status = GameStartStatus.initial,
    this.initialDeck,
  });

  final GameStartStatus status;
  final Deck? initialDeck;

  bool get isNewDeck => initialDeck == null;

  GameStartState copyWith({
    GameStartStatus? status,
    Deck? initialDeck,
    String? title,
    String? description,
  }) {
    return GameStartState(
      status: status ?? this.status,
      initialDeck: initialDeck ?? this.initialDeck,
    );
  }

  @override
  List<Object?> get props => [status, initialDeck];
}
