part of 'game_overview.bloc.dart';

enum GameOverviewStatus { initial, loading, success, failure }

class GameOverviewState extends Equatable {
  const GameOverviewState({
    this.status = GameOverviewState.initial,
    this.initialDeck,
  });

  final GameOverviewState status;
  final Deck? initialDeck;

  bool get isNewDeck => initialDeck == null;

  GameOverviewState copyWith({
    GameOverviewStatus? status,
    Deck? initialDeck,
    String? title,
    String? description,
  }) {
    return GameOverviewState(
      status: status ?? this.status,
      initialDeck: initialDeck ?? this.initialDeck,
    );
  }

  @override
  List<Object?> get props => [status, initialDeck];
}
