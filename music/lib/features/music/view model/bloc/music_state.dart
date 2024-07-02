part of 'music_bloc.dart';

@immutable
sealed class MusicState {
  final Music? music;

  const MusicState({required this.music});
}

final class MusicInitial extends MusicState {
  const MusicInitial({super.music});
}

final class MusicPlaying extends MusicState {
  const MusicPlaying({super.music});
}

final class MusicPaused extends MusicState {
  const MusicPaused({super.music});
}

final class MusicLoading extends MusicState {
  const MusicLoading({super.music});
}

final class MusicFailed extends MusicState {
  final String message;

  const MusicFailed({this.message ='something went wrong', super.music});
}
