part of 'decks.bloc.dart';

abstract class DecksEvent extends Equatable {
  const DecksEvent();

  @override
  List<Object> get props => [];
}

class DecksOverviewSubscriptionRequested extends DecksEvent {
  const DecksOverviewSubscriptionRequested();
}

class DecksOverviewDeckDeleted extends DecksEvent {
  const DecksOverviewDeckDeleted(this.deck);

  final Deck deck;

  @override
  List<Object> get props => [deck];
}

class DecksOverviewUndoDeletionRequested extends DecksEvent {
  const DecksOverviewUndoDeletionRequested();
}
