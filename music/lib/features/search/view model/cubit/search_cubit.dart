import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/features/music/view%20model/music_model.dart';
import 'package:music/features/search/repository/search_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.searchRepository) : super(SearchInitial());
  final SearchRepository searchRepository;

  Future<void> searchMusic(String value) async {
    emit(SearchLoading());
    Either<MusicModel, Failure> result =
        await searchRepository.searchMusic(value);
    result.fold(
      (musicmodel) => emit(SearchSuccess(musicmodel.music)),
      (failure) => emit(SearchFailed(failure.failure)),
    );
  }
}
