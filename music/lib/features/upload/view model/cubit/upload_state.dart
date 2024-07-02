part of 'upload_cubit.dart';

@immutable
sealed class UploadState {}

final class UploadInitial extends UploadState {}

final class UploadLoading extends UploadState {}

final class UploadSuccess extends UploadState {
  UploadSuccess(this.message);
  final String message;
}

final class UploadFailure extends UploadState {
  UploadFailure(this.message);
  final String message;
}
