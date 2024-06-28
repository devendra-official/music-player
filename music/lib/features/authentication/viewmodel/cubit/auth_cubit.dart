import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/features/authentication/repository/authrepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authrepository, required this.preferences})
      : super(AuthInitial());

  final Authrepository authrepository;
  final SharedPreferences preferences;

  void signup({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    Either<String, Failure> res = await authrepository.signup(
      name: name,
      email: email,
      password: password,
    );

    res.fold(
      (message) => emit(AuthSignUpSucsess(message)),
      (failure) => emit(AuthSignUpFailure(message: failure.failure)),
    );
  }

  void signin({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    Either<String, Failure> res = await authrepository.signin(
      email: email,
      password: password,
    );
    res.fold(
      (token) async {
        await preferences.setString("token", token);
        emit(AuthSignInSucsess(token: token));
      },
      (failure) => emit(AuthSignInFailure(message: failure.failure)),
    );
  }
}
