import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/features/music/repository/getlistrepo.dart';
import 'package:music/features/music/viewmodel/music_model.dart';

part 'audiolist_state.dart';

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
