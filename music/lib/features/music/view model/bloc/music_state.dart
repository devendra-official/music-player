part of 'music_bloc.dart';

@immutable
sealed class MusicState {
  final Music? music;
  final int? currentId;

  const MusicState({required this.music, required this.currentId});
}

final class MusicInitial extends MusicState {
  const MusicInitial({super.music, super.currentId});
}

final class MusicPlaying extends MusicState {
  const MusicPlaying({super.music, super.currentId});
}

final class MusicPaused extends MusicState {
  const MusicPaused({super.music, super.currentId});
}

final class MusicLoading extends MusicState {
  const MusicLoading({super.music, super.currentId});
}

final class MusicFailed extends MusicState {
  final String message;

  const MusicFailed(
      {this.message = 'something went wrong', super.music, super.currentId});
}
