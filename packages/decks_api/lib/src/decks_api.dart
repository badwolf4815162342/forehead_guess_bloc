import 'package:decks_api/decks_api.dart';

/// {@template todos_api}
/// The interface for an API that provides access to a list of todos.
/// {@endtemplate}
abstract class DecksApi {
  /// {@macro todos_api}
  const DecksApi();

  /// Provides a [Stream] of all todos.
  Stream<List<Deck>> getDecks();

  /// Saves a [todo].
  ///
  /// If a [todo] with the same id already exists, it will be replaced.
  Future<void> saveDeck(Deck todo);

  /// Deletes the todo with the given id.
  ///
  /// If no todo with the given id exists, a [TodoNotFoundException] error is
  /// thrown.
  Future<void> deleteDeck(String id);

  /// Deletes all completed todos.
  ///
  /// Returns the number of deleted todos.
  Future<int> clearCompleted();

  /// Sets the `isCompleted` state of all todos to the given value.
  ///
  /// Returns the number of updated todos.
  Future<int> completeAll({required bool isCompleted});
}

/// Error thrown when a [Deck] with a given id is not found.
class DeckNotFoundException implements Exception {}
