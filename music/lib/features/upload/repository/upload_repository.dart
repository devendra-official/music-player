import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/core/server/server_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadRepository {
  UploadRepository({required this.client, required this.preferences});
  final Client client;
  final SharedPreferences preferences;

  Future<Either<String, Failure>> uploadMusic({
    required String imageurl,
    required String audiourl,
    required String movie,
    required String artist,
    required String musicName,
    required String color,
  }) async {
    try {
      String? token = preferences.getString("token");
      if (token == null) {
        return Right(Failure("Authentication failed"));
      }
      Response response = await client.post(
        headers: {'x-auth-token': token, 'Content-Type': "Application/json"},
        body: jsonEncode({
          "musicurl": audiourl,
          "name": musicName,
          "movie": movie,
          "imageurl": imageurl,
          "artist": artist,
          "color": color
        }),
        Uri.parse("${ServerConfig.serverIP}/music/upload"),
      );
      final uploadData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return Left(uploadData["msg"]);
      }
      return Right(Failure(uploadData["msg"]));
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }
}
