import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/core/server/server_config.dart';
import 'package:music/features/authentication/view%20model/user_model.dart';
import 'package:music/features/music/view%20model/music_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepository {
  final Client client;
  final SharedPreferences preferences;

  SearchRepository({required this.client, required this.preferences});
  Future<Either<MusicModel, Failure>> searchMusic(String value) async {
    try {
      String? userData = preferences.getString("userData");
      if (userData == null) {
        return Right(Failure('Authentication failed please login again'));
      }
      UserModel userModel = UserModel.fromJson(jsonDecode(userData));

      Response response = await client.post(
        headers: {
          "x-auth-token": userModel.token,
          'Content-Type': "Application/json"
        },
        body: jsonEncode({"value": value}),
        Uri.parse('${ServerConfig.serverIP}/music/search'),
      );
      final musicData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Left(MusicModel.fromJson(musicData));
      }
      return Right(Failure(musicData["msg"]));
    } catch (e) {
      return Right(Failure('failed to search'));
    }
  }
}
