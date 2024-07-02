import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music/core/theme/theme.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/authentication/view/pages/login.dart';
import 'package:music/features/authentication/view%20model/cubit/auth_cubit.dart';
import 'package:music/features/music/view/pages/bottom.dart';
import 'package:music/features/music/view%20model/bloc/music_bloc.dart';
import 'package:music/features/music/view%20model/cubit/audiolist_cubit.dart';
import 'package:music/features/search/view%20model/cubit/search_cubit.dart';
import 'package:music/features/upload/view%20model/cubit/upload_cubit.dart';
import 'package:music/init_dependency.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Music Player',
    androidNotificationOngoing: true,
  );
  await initdependencyfun();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => serviceLocator<AuthCubit>()),
      BlocProvider(create: (context) => serviceLocator<UploadCubit>()),
      BlocProvider(create: (context) => serviceLocator<AudiolistCubit>()),
      BlocProvider(create: (context) => MusicBloc()),
      BlocProvider(create: (context) => serviceLocator<SearchCubit>()),
      BlocProvider(create: (context) => serviceLocator<UserCubit>())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences = serviceLocator<SharedPreferences>();
    String? userData = preferences.getString('userData');
    serviceLocator<StreamController<bool>>()
        .add(userData == null ? false : true);
    BlocProvider.of<UserCubit>(context).initialize(userData);

    return MaterialApp(
      title: 'Music Application',
      theme: theme,
      home: StreamBuilder<bool>(
        stream: serviceLocator<StreamController<bool>>().stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data ?? false) {
              return const BottomNavItems();
            }
          }
          return const Login();
        },
      ),
    );
  }
}
