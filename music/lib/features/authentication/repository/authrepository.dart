import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/core/server/server.dart';
import 'package:music/features/authentication/view%20model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authrepository {
  Authrepository(this.client, this.preferences);
  final Client client;
  final SharedPreferences preferences;

  Future<Either<String, Failure>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      String server =
          preferences.getString("server") ?? ServerCubit.serverIP;
      final response = await client.post(
        headers: {'Content-Type': "Application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
        Uri.parse("$server/users/add-user"),
      );
      final userData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return const Left("Sign-up successful");
      }
      return Right(Failure(userData["msg"]));
    } catch (e) {
      return Right(Failure("signup failed,Try Again!"));
    }
  }

  Future<Either<UserModel, Failure>> signin({
    required String email,
    required String password,
  }) async {
    try {
      String server =
          preferences.getString("server") ?? ServerCubit.serverIP;
      final response = await client.post(
        headers: {'Content-Type': "Application/json"},
        body: jsonEncode({"email": email, "password": password}),
        Uri.parse("$server/users/signin"),
      );
      final userData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Left(UserModel.fromJson(userData));
      }
      return Right(Failure(userData["msg"]));
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }
}
