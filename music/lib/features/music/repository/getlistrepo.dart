import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:music/core/error/failure.dart';
import 'package:music/core/server/server_config.dart';
import 'package:music/features/music/viewmodel/music_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioListRepository {
  AudioListRepository({required this.client, required this.preferences});
  final Client client;
  final SharedPreferences preferences;

  Future<Either<MusicModel, Failure>> getList() async {
    try {
      String? token = preferences.getString("token");
      if (token == null) {
        return Right(Failure('Authentication failed please login again'));
      }
      Response response = await client.get(
        headers: {"x-auth-token": token},
        Uri.parse("${ServerConfig.serverIP}/music/list"),
      );
      final musicData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Left(MusicModel.fromJson(musicData));
      }
      return Right(Failure(musicData["msg"]));
    } catch (e) {
      return Right(Failure(e.toString()));
    }
  }
}
