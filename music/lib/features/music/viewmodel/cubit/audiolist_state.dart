part of 'audiolist_cubit.dart';

@immutable
sealed class AudiolistState {}

final class AudiolistInitial extends AudiolistState {}

final class AudiolistSuccess extends AudiolistState {
  final MusicModel musicModel;

  AudiolistSuccess({required this.musicModel});
}

final class AudiolistLoading extends AudiolistState {}

final class AudiolistFailure extends AudiolistState {
  final String message;

  AudiolistFailure({required this.message});
}
