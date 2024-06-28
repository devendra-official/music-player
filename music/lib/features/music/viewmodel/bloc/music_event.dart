part of 'music_bloc.dart';

@immutable
sealed class MusicEvent {}

class MusicPlay extends MusicEvent {
  final Music music;

  MusicPlay({required this.music});
}

class MusicPausePlay extends MusicEvent {}
