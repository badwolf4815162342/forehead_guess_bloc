part of 'deck_edit.bloc.dart';

enum DeckEditStatus { initial, loading, success, failure }

extension DeckEditStatusX on DeckEditStatus {
  bool get isLoadingOrSuccess => [
        DeckEditStatus.loading,
        DeckEditStatus.success,
      ].contains(this);
}

class DeckEditState extends Equatable {
  const DeckEditState({
    this.status = DeckEditStatus.initial,
    this.initialDeck,
    this.name = '',
    this.image = '',
    this.words = '',
  });

  final DeckEditStatus status;
  final Deck? initialDeck;
  final String name;
  final String image;
  final String words;

  bool get isNewDeck => initialDeck == null;

  DeckEditState copyWith({
    DeckEditStatus? status,
    Deck? initialDeck,
    String? title,
    String? description,
  }) {
    return DeckEditState(
      status: status ?? this.status,
      initialDeck: initialDeck ?? this.initialDeck,
      name: name ?? this.name,
      image: image ?? this.image,
      words: words ?? this.words,
    );
  }

  @override
  List<Object?> get props => [status, initialDeck, name, image, words];
}
