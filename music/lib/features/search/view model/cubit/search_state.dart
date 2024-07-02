part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchSuccess extends SearchState {
  final List<Music> music;

  SearchSuccess(this.music);
}

final class SearchFailed extends SearchState {
  final String message;

  SearchFailed(this.message);
}
