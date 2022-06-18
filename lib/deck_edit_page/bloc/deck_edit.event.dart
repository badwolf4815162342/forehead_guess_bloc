part of 'deck_edit.bloc.dart';

abstract class DeckEditEvent extends Equatable {
  const DeckEditEvent();

  @override
  List<Object> get props => [];
}

class EditTodoNameChanged extends DeckEditEvent {
  const EditTodoNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class EditTodoImageChanged extends DeckEditEvent {
  const EditTodoImageChanged(this.image);

  final String image;

  @override
  List<Object> get props => [image];
}

class EditTodoWordsChanged extends DeckEditEvent {
  const EditTodoWordsChanged(this.words);

  final String words;

  @override
  List<Object> get props => [words];
}

class EditTodoSubmitted extends DeckEditEvent {
  const EditTodoSubmitted();
}
