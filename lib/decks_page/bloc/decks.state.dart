part of 'decks.bloc.dart';

enum DecksOverviewStatus { initial, loading, success, failure }

class DecksOverviewState extends Equatable {
  const DecksOverviewState({
    this.status = DecksOverviewStatus.initial,
    this.decks = const [],
    this.lastDeletedDeck,
  });

  final DecksOverviewStatus status;
  final List<Deck> decks;
  final Deck? lastDeletedDeck;

  DecksOverviewState copyWith({
    DecksOverviewStatus Function()? status,
    List<Deck> Function()? decks,
    Deck? Function()? lastDeletedDeck,
  }) {
    return DecksOverviewState(
      status: status != null ? status() : this.status,
      decks: decks != null ? decks() : this.decks,
      lastDeletedDeck:
          lastDeletedDeck != null ? lastDeletedDeck() : this.lastDeletedDeck,
    );
  }

  @override
  List<Object?> get props => [
        status,
        decks,
        lastDeletedDeck,
      ];
}
