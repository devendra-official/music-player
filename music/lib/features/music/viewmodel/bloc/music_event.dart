part of 'music_bloc.dart';

@immutable
sealed class MusicEvent {}

class MusicPlay extends MusicEvent {
  final Music music;

  MusicPlay({required this.music});
}

class MusicStateEvent extends MusicEvent {
  final PlayerState playerSubscription;

  MusicStateEvent({required this.playerSubscription});
}

class MusicChange extends MusicEvent {}

class MusicPausePlay extends MusicEvent {}
