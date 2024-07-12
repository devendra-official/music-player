import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/core/server/server.dart';
import 'package:music/core/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadRepository {
  UploadRepository({required this.client, required this.preferences});
  final Client client;
  final SharedPreferences preferences;

  Future<Either<String, Failure>> uploadMusic({
    required String imageurl,
    required String audiourl,
    required String album,
    required String artist,
    required String musicName,
    required String language,
  }) async {
    try {
      String server =
          preferences.getString("server") ?? ServerCubit.serverIP;
      String? userData = preferences.getString("userData");
      if (userData == null) {
        return Right(Failure('Authentication failed please login again'));
      }
      UserModel userModel = UserModel.fromJson(jsonDecode(userData));
      Response response = await client.post(
        headers: {
          'x-auth-token': userModel.token,
          'Content-Type': "Application/json"
        },
        body: jsonEncode({
          "musicurl": audiourl,
          "name": musicName,
          "album": album,
          "imageurl": imageurl,
          "artist": artist,
          "language": language
        }),
        Uri.parse("$server/music/upload"),
      );
      final uploadData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return Left(uploadData["msg"]);
      }
      return Right(Failure(uploadData["msg"]));
    } catch (e) {
      return Right(Failure("failed to upload music"));
    }
  }
}
