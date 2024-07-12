part of 'music_bloc.dart';

@immutable
sealed class MusicEvent {}

class MusicPlay extends MusicEvent {
  final Music music;
  final int index;
  final List<Music> musicList;

  MusicPlay(
      {required this.music, required this.index, required this.musicList});
}

class MusicUpdate extends MusicEvent {
  final Music music;
  MusicUpdate({required this.music});
}

class MusicStateEvent extends MusicEvent {
  final PlayerState playerSubscription;

  MusicStateEvent({required this.playerSubscription});
}

class MusicPausePlay extends MusicEvent {}

class MusicDispose extends MusicEvent {}

class MusicError extends MusicEvent {
  final String error;

  MusicError({required this.error});
}
