import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/features/authentication/view%20model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      showCloseIcon: true,
      content: Text(message),
    ),
  );
}

class UserCubit extends Cubit<UserModel?> {
  UserCubit(this.preferences) : super(null);

  final SharedPreferences preferences;

  void initialize(String? userData) {
    if (userData != null) {
      return emit(UserModel.fromJson(jsonDecode(userData)));
    }
    return emit(null);
  }
}
