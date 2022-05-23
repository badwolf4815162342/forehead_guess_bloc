class Deck {
  String _name;
  String _fileName;
  String _image;
  List<String> _words;

  String get name => _name;

  String get fileName => _fileName;

  String get image => _image;

  List<String> get words => _words;

  Deck(this._name, this._fileName, this._image, this._words);

  factory Deck.fromWordsString(
      String path, String name, String image, String words) {
    List<String> wordsList = [];
    words.toString().split(',').forEach((element) {
      wordsList.add(element.trim());
    });
    wordsList.removeWhere((v) => v == '');
    return Deck(name, path, image, wordsList);
  }
  factory Deck.empty(String path, String name, String image, String words) {
    return Deck('', '', '', []);
  }

  factory Deck.withoutPath(
      String path, String name, String image, String words) {
    List<String> wordsList = [];
    words.toString().split(',').forEach((element) {
      wordsList.add(element.trim());
    });
    return Deck(name, '', image, wordsList);
  }

  void setFileName(String fileName) {
    this._fileName = fileName;
  }

  Deck.fromJson(Map<String, dynamic> json)
      : _fileName = json['filename'],
        _name = json['name'],
        _image = json['image'],
        _words = json['words'].toString().split(',');

  Map<String, dynamic> toJson() => {
        'filename': _fileName,
        'name': _name,
        'image': _image,
        'words': _words.join(',')
      };
}
