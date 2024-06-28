import 'package:cloudinary/cloudinary.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:music/core/secrets/api_key.dart';
import 'package:music/features/authentication/repository/authrepository.dart';
import 'package:music/features/authentication/viewmodel/cubit/auth_cubit.dart';
import 'package:music/features/music/repository/getlistrepo.dart';
import 'package:music/features/music/viewmodel/cubit/audiolist_cubit.dart';
import 'package:music/features/upload/repository/upload_repository.dart';
import 'package:music/features/upload/viewmodel/cubit/upload_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initdependencyfun() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  serviceLocator.registerFactory(() => http.Client());
  serviceLocator
      .registerFactory<Authrepository>(() => Authrepository(serviceLocator()));
  serviceLocator.registerLazySingleton<AuthCubit>(() =>
      AuthCubit(authrepository: serviceLocator(), preferences: preferences));

  serviceLocator.registerLazySingleton(
    () => Cloudinary.signedConfig(
      apiKey: CloudinaryKey.apiKey,
      apiSecret: CloudinaryKey.apiSecret,
      cloudName: CloudinaryKey.cloudName,
    ),
  );
  serviceLocator.registerFactory(
    () => UploadRepository(
      client: serviceLocator(),
      preferences: preferences,
    ),
  );
  serviceLocator.registerLazySingleton<UploadCubit>(
    () => UploadCubit(
      cloudinary: serviceLocator(),
      preferences: preferences,
      uploadRepository: serviceLocator(),
    ),
  );

  // AUDIO LIST
  serviceLocator.registerFactory(() =>
      AudioListRepository(client: serviceLocator(), preferences: preferences));
  serviceLocator.registerLazySingleton<AudiolistCubit>(
      () => AudiolistCubit(serviceLocator()));
}
