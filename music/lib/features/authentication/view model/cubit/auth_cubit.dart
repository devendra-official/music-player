import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/authentication/repository/authrepository.dart';
import 'package:music/core/model/user_model.dart';
import 'package:music/features/music/view%20model/bloc/music_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.authrepository,
    required this.preferences,
    required this.authStreamController,
  }) : super(AuthInitial());

  final Authrepository authrepository;
  final SharedPreferences preferences;
  final StreamController<bool> authStreamController;

  Future<void> autologin(BuildContext context) async {
    String? userData = preferences.getString('userData');
    authStreamController.add(userData != null);
    context.read<UserCubit>().initialize(userData);
  }

  Future<void> signup({
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

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    Either<UserModel, Failure> res = await authrepository.signin(
      email: email,
      password: password,
    );
    res.fold(
      (usermodel) async {
        await preferences.setString(
          "userData",
          jsonEncode(usermodel.toJson()),
        );
        authStreamController.add(true);
        emit(AuthSignInSucsess(userModel: usermodel));
      },
      (failure) => emit(AuthSignInFailure(message: failure.failure)),
    );
  }

  Future<void> logout(BuildContext context) async {
    BlocProvider.of<MusicBloc>(context).add(MusicDispose());
    await preferences.remove('userData');
    authStreamController.add(false);
  }
}
