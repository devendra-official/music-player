import 'dart:async';

import 'package:cloudinary/cloudinary.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:music/core/secrets/api_key.dart';
import 'package:music/core/server/server.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/authentication/repository/authrepository.dart';
import 'package:music/features/authentication/view%20model/cubit/auth_cubit.dart';
import 'package:music/features/music/repository/getlistrepo.dart';
import 'package:music/features/music/view%20model/bloc/music_bloc.dart';
import 'package:music/features/music/view%20model/cubit/audiolist_cubit.dart';
import 'package:music/features/music/view%20model/cubit/music_lan.dart';
import 'package:music/features/search/repository/search_repository.dart';
import 'package:music/features/search/view%20model/cubit/search_cubit.dart';
import 'package:music/features/upload/repository/upload_repository.dart';
import 'package:music/features/upload/view%20model/cubit/upload_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initdependencyfun() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  serviceLocator.registerFactory(() => preferences);
  serviceLocator.registerFactory(() => http.Client());
  serviceLocator
      .registerFactory<Authrepository>(() => Authrepository(serviceLocator(),serviceLocator()));

  serviceLocator.registerLazySingleton<StreamController<bool>>(
      () => StreamController<bool>(),
      instanceName: 'authStream');

  serviceLocator.registerLazySingleton(
    () => Cloudinary.signedConfig(
      apiKey: SecretKey.apiKey,
      apiSecret: SecretKey.apiSecret,
      cloudName: SecretKey.cloudName,
    ),
  );

  serviceLocator.registerFactory(
    () => UploadRepository(
      client: serviceLocator(),
      preferences: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(() => AudioListRepository(
      client: serviceLocator(), preferences: serviceLocator()));

  serviceLocator.registerFactory(
    () => SearchRepository(
      client: serviceLocator(),
      preferences: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => UploadCubit(
      cloudinary: serviceLocator(),
      preferences: serviceLocator(),
      uploadRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AuthCubit(
      authrepository: serviceLocator(),
      preferences: serviceLocator(),
      authStreamController:
          serviceLocator<StreamController<bool>>(instanceName: 'authStream'),
    ),
  );
  serviceLocator.registerLazySingleton(() => AudiolistCubit(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SearchCubit(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UserCubit(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => MusicByLanguageCubit(serviceLocator()));
  serviceLocator.registerLazySingleton(() => MusicBloc());

  serviceLocator.registerLazySingleton(() => ServerCubit(serviceLocator()));
}
