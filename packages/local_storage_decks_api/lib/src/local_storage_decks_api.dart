import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:decks_api/decks_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_decks_api}
/// A Flutter implementation of the [DecksApi] that uses local storage.
/// {@endtemplate}
class LocalStorageDecksApi extends DecksApi {
  /// {@macro local_storage_todos_api}
  LocalStorageDecksApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _deckStreamController = BehaviorSubject<List<Deck>>.seeded(const []);

  /// The key used for storing the todos locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kDecksCollectionKey = '__decks_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final decksJson = _getValue(kDecksCollectionKey);
    if (decksJson != null) {
      final decks = List<Map>.from(json.decode(decksJson) as List)
          .map((jsonMap) => Deck.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _deckStreamController.add(decks);
    } else {
      _initFirstTime();
      //_deckStreamController.add(const []);
    }
  }

  Future<void> _initFirstTime() async {
    List<Deck> decks = [];

    final path = await _localPath;

    final dir = Directory(path);
    final List<FileSystemEntity> entities = await dir.list().toList();

    final List<FileSystemEntity> filteredEntities = List.from(entities)
      ..removeWhere((value) => !isGameJson(value));

    if (filteredEntities.isEmpty) {
      // THROW ERROR!!
      final manifestContent = await rootBundle.loadString('AssetManifest.json');

      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final imagePaths = manifestMap.keys
          .where((String key) => key.contains('assets/'))
          .where((String key) => key.contains('.json'))
          .toList();
      _initDecksFromAssets(imagePaths).then((value) {
        return;
      });
    } else {
      // THROW ERROR
      /**
      await _initDecksFromLocalFiles(filteredEntities).then((value) {
        return;
      }); */
    }
    _deckStreamController.add(decks);
  }

  bool isGameJson(FileSystemEntity value) {
    if (value is File) {
      if (value.path.endsWith('.json')) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  _initDecksFromAssets(List<String> imagePaths) async {
    // _decks.clear();
    List<Deck> decks = [];
    for (final path in imagePaths) {
      loadAsset(path).then((String contents) {
        Map<String, dynamic> userMap = jsonDecode(contents);
        var deck = Deck.fromJson(userMap);
        deck.filename = (path.substring(7, path.length));
        decks.add(deck);
        // CHECK IF IMAGE IS WORKING
      });
    }
    _deckStreamController.add(decks);
    return;
  }

  /**_initDecksFromLocalFiles(List<FileSystemEntity> entities) async {
    List<Deck> decks = [];
    for (final entity in entities) {
      if (entity is File) {
        String contents = entity.readAsStringSync();
        Map<String, dynamic> userMap = jsonDecode(contents);
        var deck = Deck.fromJson(userMap);
        // CHECK IF IMAGE IS WORKING
        decks.add(deck);
      }
    }
    _deckStreamController.add(decks);
  }*/

  Future<String> loadAsset(String fileName) async {
    return await rootBundle.loadString(fileName);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  /**

  


  Future<File> getLocalFile(String fileName) async {
    final path = await _localPath;
    String filePath = path + '/' + fileName;
    print('1.FilePathfor (_writeJson) _newJson: $filePath');
    return File(filePath);
  } */

  @override
  Stream<List<Deck>> getDecks() => _deckStreamController.asBroadcastStream();

  @override
  Future<void> saveDeck(Deck deck) {
    final decks = [..._deckStreamController.value];
    final DeckIndex = decks.indexWhere((t) => t.filename == deck.filename);
    if (DeckIndex >= 0) {
      decks[DeckIndex] = deck;
    } else {
      decks.add(deck);
    }

    _deckStreamController.add(decks);
    return _setValue(kDecksCollectionKey, json.encode(decks));
  }

  @override
  Future<void> deleteDeck(String fileName) async {
    final decks = [..._deckStreamController.value];
    final DeckIndex = decks.indexWhere((t) => t.filename == fileName);
    if (DeckIndex == -1) {
      throw DeckNotFoundException();
    } else {
      decks.removeAt(DeckIndex);
      _deckStreamController.add(decks);
      return _setValue(kDecksCollectionKey, json.encode(decks));
    }
  }
}
