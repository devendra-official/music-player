part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSignUpSucsess extends AuthState {
  final String message;
  AuthSignUpSucsess(this.message);
}

final class AuthSignInSucsess extends AuthState {
  final UserModel userModel;

  AuthSignInSucsess({required this.userModel});
}

final class AuthSignInFailure extends AuthState {
  final String message;

  AuthSignInFailure({required this.message});
}

final class AuthSignUpFailure extends AuthState {
  final String message;

  AuthSignUpFailure({required this.message});
}
