import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:decks_api/decks_api.dart';
// import 'package:uuid/uuid.dart';

/// {@template deck}
/// A single deck item.
///
/// Contains a [filename], [name] and [image], in addition to a [words]
/// list.
///
///
/// [Deck]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
///

@immutable
@JsonSerializable()
class Deck extends Equatable {
  /// {@macro todo}
  Deck({
    required this.filename,
    required this.name,
    this.image = '',
    this.words = const [''],
  });
  /**   : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();*/

  /// The unique identifier of the todo.
  ///
  /// Cannot be empty.
  String filename;
  set fileName(String fileName) {
    filename = fileName;
  }

  /// The title of the todo.
  ///
  /// Note that the title may be empty.
  final String name;

  /// The description of the todo.
  ///
  /// Defaults to an empty string.
  final String image;

  /// Whether the todo is completed.
  ///
  /// Defaults to `false`.
  final List<String> words;

  /// Returns a copy of this todo with the given values updated.
  ///
  /// {@macro todo}
  Deck copyWith({
    String? filename,
    String? name,
    String? image,
    List<String>? words,
  }) {
    return Deck(
      filename: filename ?? this.filename,
      name: name ?? this.name,
      image: image ?? this.image,
      words: words ?? this.words,
    );
  }

  Deck.fromJson(Map<String, dynamic> json)
      : filename = json['filename'],
        name = json['name'],
        image = json['image'],
        words = json['words'].toString().split(',');

  Map<String, dynamic> toJson() => {
        'filename': filename,
        'name': name,
        'image': image,
        'words': words.join(',')
      };

  @override
  List<Object> get props => [filename, name, image, words];
}
