import 'package:decks_api/decks_api.dart';

/// {@template decks_repository}
/// A repository that handles deck related requests.
/// {@endtemplate}
class DecksRepository {
  /// {@macro decks_repository}
  const DecksRepository({
    required DecksApi decksApi,
  }) : _decksApi = decksApi;

  final DecksApi _decksApi;

  /// Provides a [Stream] of all decks.
  Stream<List<Deck>> getDecks() => _decksApi.getDecks();

  /// Saves a [deck].
  ///
  /// If a [deck] with the same id already exists, it will be replaced.
  Future<void> saveDeck(Deck deck) => _decksApi.saveDeck(deck);

  /// Deletes the deck with the given id.
  ///
  /// If no deck with the given id exists, a [DeckNotFoundException] error is
  /// thrown.
  Future<void> deleteDeck(String id) => _decksApi.deleteDeck(id);
}
