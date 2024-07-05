import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/features/music/repository/getlistrepo.dart';
import 'package:music/features/music/view%20model/music_model.dart';

class AudiolistCubit extends Cubit<AudiolistState> {
  AudiolistCubit(this.audioListRepository) : super(AudiolistInitial());

  final AudioListRepository audioListRepository;

  void getList() async {
    emit(AudiolistLoading());
    Either<MusicModel, Failure> result = await audioListRepository.getList();
    result.fold(
      (music) => emit(AudiolistSuccess(musicModel: music)),
      (failure) => emit(AudiolistFailure(message: failure.failure)),
    );
  }
}

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
