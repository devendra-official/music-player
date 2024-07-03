import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/core/server/server_config.dart';
import 'package:music/features/authentication/view%20model/user_model.dart';

class Authrepository {
  Authrepository(this.client);
  final Client client;

  Future<Either<String, Failure>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        headers: {'Content-Type': "Application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
        Uri.parse("${ServerConfig.serverIP}/users/add-user"),
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
      final response = await client.post(
        headers: {'Content-Type': "Application/json"},
        body: jsonEncode({"email": email, "password": password}),
        Uri.parse("${ServerConfig.serverIP}/users/signin"),
      );
      final userData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Left(UserModel.fromJson(userData));
      }
      return Right(Failure(userData["msg"]));
    } catch (e) {
      return Right(Failure("login failed,Try Again!"));
    }
  }
}
