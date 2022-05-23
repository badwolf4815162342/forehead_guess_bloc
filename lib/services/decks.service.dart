import "dart:math";
import 'dart:convert';
import 'dart:io';
import 'dart:async' show Future;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/deck.model.dart';
import 'package:path_provider/path_provider.dart';

class DecksService extends ChangeNotifier {
  Deck _currentDeck = Deck('', 'nulldeck', 'nullimage', []);
  List<Deck> _decks = [];
  Map<String, bool> _resultWords = {};
  bool _isLoading = true;
  String _currentWord = '';
  bool _gameEnded = false;

  DecksService() {
    initialize();
  }

  initialize() async {
    _isLoading = true;
    notifyListeners();

    final path = await _localPath;

    final dir = Directory(path);
    final List<FileSystemEntity> entities = await dir.list().toList();

    final filteredEntities = List.from(entities)
      ..removeWhere((value) => !isGameJson(value));

    if (filteredEntities.isEmpty) {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');

      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final imagePaths = manifestMap.keys
          .where((String key) => key.contains('assets/'))
          .where((String key) => key.contains('.json'))
          .toList();
      await _initDecksFromAssets(imagePaths).then((value) {
        _isLoading = false;
        notifyListeners();
        return;
      });
    } else {
      await _initDecksFromLocalFiles(entities).then((value) {
        _isLoading = false;
        notifyListeners();
        return;
      });
    }
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

  Future<void> _initDecksFromAssets(List<String> imagePaths) async {
    _decks.clear();
    for (final path in imagePaths) {
      loadAsset(path).then((String contents) {
        Map<String, dynamic> userMap = jsonDecode(contents);
        var deck = Deck.fromJson(userMap);
        deck.setFileName(path.substring(7, path.length));
        // CHECK IF IMAGE IS WORKING
        _decks.add(deck);
        writeDeck(deck);
      });
    }
    notifyListeners();
    return;
  }

  Future<void> _initDecksFromLocalFiles(List<FileSystemEntity> entities) async {
    _decks.clear();
    for (final entity in entities) {
      if (entity is File) {
        String contents = (entity as File).readAsStringSync();
        Map<String, dynamic> userMap = jsonDecode(contents);
        var deck = Deck.fromJson(userMap);
        // CHECK IF IMAGE IS WORKING
        _decks.add(deck);
      }
    }
    notifyListeners();
  }

  Future<String> loadAsset(String fileName) async {
    return await rootBundle.loadString(fileName);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> getLocalFile(String fileName) async {
    final path = await _localPath;
    String filePath = path + '/' + fileName;
    print('1.FilePathfor (_writeJson) _newJson: $filePath');
    return File(filePath);
  }

  Future<File> updateCurrentDeck(Deck updatedDeck) async {
    _decks.remove(_currentDeck);
    _currentDeck = updatedDeck;
    _decks.add(_currentDeck);
    notifyListeners();
    return writeDeck(_currentDeck);
  }

  Future<File> writeDeck(Deck newDeck) async {
    final file = await getLocalFile(newDeck.fileName);
    Map<String, dynamic> _newJson = newDeck.toJson();
    print('1.(_writeJson) _newJson: $_newJson');

    String _jsonString = jsonEncode(_newJson);
    print('3.(_writeJson) _jsonString: $_jsonString\n - \n');

    // Write the file
    return file.writeAsString(_jsonString);
  }

  bool get gameEnded => _gameEnded;

  bool get isLoading => _isLoading;

  String get currentWord => _currentWord;

  Deck get currentDeck => _currentDeck;

  List<Deck> get decks => _decks;

  Map<String, bool> getResultWords() => _resultWords;

  List<String> getDeckNames() {
    List<String> names = [];
    for (var deck in _decks) {
      names.add(deck.name);
    }
    return names;
  }

  int getWordCountCorrect() {
    final filteredMap = Map.from(_resultWords)..removeWhere((k, v) => !v);
    return filteredMap.length;
  }

  int getWordCountIncorrect() {
    final filteredMap = Map.from(_resultWords)..removeWhere((k, v) => v);
    return filteredMap.length;
  }

  void setCurrentDeck(int index) {
    _resultWords = {};
    _currentDeck = _decks[index];
    notifyListeners();
  }

  void resetCurrentDeck() {
    _currentDeck = Deck('', 'nulldeck', 'nullimage', []);
    _resultWords = {};
    _currentWord = '';
  }

  void resetGame() {
    _resultWords = {};
    _gameEnded = false;
    final _random = Random();
    _currentWord =
        _currentDeck.words[_random.nextInt(_currentDeck.words.length)];
  }

  void saveWordAndSetNewRandom(bool correct) {
    _resultWords[_currentWord] = correct;
    if (_resultWords.length == _currentDeck.words.length) {
      _gameEnded = true;
      _currentWord = "Deck empty!";
    } else {
      var set1 = Set.from(_currentDeck.words);
      var set2 = Set.from(_resultWords.keys);
      List<String> wordsToChooseFrom =
          List.from(List.from(set1.difference(set2)));
      final _random = new Random();

      _currentWord =
          wordsToChooseFrom[_random.nextInt(wordsToChooseFrom.length)];
    }
    notifyListeners();
  }
}
