part of 'game.bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class CorrectEvent extends GameEvent {
  const CorrectEvent(this.currentWord);

  final String currentWord;

  @override
  List<Object> get props => [currentWord];
}

class TimerEndedEvent extends GameEvent {
  const TimerEndedEvent();

  @override
  List<Object> get props => [];
}

class IncorrectEvent extends GameEvent {
  const IncorrectEvent(this.currentWord);

  final String currentWord;

  @override
  List<Object> get props => [currentWord];
}
