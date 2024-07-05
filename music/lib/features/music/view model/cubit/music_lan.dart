import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/features/music/repository/getlistrepo.dart';
import 'package:music/features/music/view%20model/music_model.dart';

class MusicByLanguageCubit extends Cubit<MusicByLanguageState> {
  MusicByLanguageCubit(this.audioListRepository)
      : super(MusicByLanguageInitial());

  AudioListRepository audioListRepository;

  Future<void> getListByLanguage() async {
    emit(MusicByLanguageLoading());
    Either<Map<String, dynamic>, Failure> result =
        await audioListRepository.getByLanguage();
    result.fold(
      (music) {
        Map<String, MusicModel> musicData = {};
        List<String> languages = [];

        for (var i = 0; i < music["languages"].length; i++) {
          languages.add(music["languages"][i]);
          musicData[music["languages"][i]] =
              MusicModel.fromJson(music[music["languages"][i]]);
        }
        return emit(
            MusicByLanguageSuccess(languages: languages, musicData: musicData));
      },
      (failure) => emit(MusicByLanguageFailure(message: failure.failure)),
    );
  }
}

class MusicByLanguageState {}

class MusicByLanguageInitial extends MusicByLanguageState {}

class MusicByLanguageFailure extends MusicByLanguageState {
  final String message;

  MusicByLanguageFailure({required this.message});
}

class MusicByLanguageSuccess extends MusicByLanguageState {
  final List<String> languages;
  final Map<String, MusicModel> musicData;

  MusicByLanguageSuccess({required this.languages, required this.musicData});
}

class MusicByLanguageLoading extends MusicByLanguageState {}
