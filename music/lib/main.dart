import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music/core/secrets/api_key.dart';
import 'package:music/core/server/server.dart';
import 'package:music/core/theme/theme.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/authentication/view/pages/login.dart';
import 'package:music/features/authentication/view%20model/cubit/auth_cubit.dart';
import 'package:music/features/music/view%20model/cubit/music_lan.dart';
import 'package:music/features/music/view/pages/bottom.dart';
import 'package:music/features/music/view%20model/bloc/music_bloc.dart';
import 'package:music/features/music/view%20model/cubit/audiolist_cubit.dart';
import 'package:music/features/search/view%20model/cubit/search_cubit.dart';
import 'package:music/features/upload/view%20model/cubit/upload_cubit.dart';
import 'package:music/init_dependency.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Supabase.initialize(
    url: SecretKey.supabaseurl,
    anonKey: SecretKey.supabaseannon,
  );

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
      BlocProvider(create: (context) => serviceLocator<MusicBloc>()),
      BlocProvider(create: (context) => serviceLocator<SearchCubit>()),
      BlocProvider(create: (context) => serviceLocator<UserCubit>()),
      BlocProvider(create: (context) => serviceLocator<MusicByLanguageCubit>()),
      BlocProvider(create: (context) => serviceLocator<ServerCubit>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthCubit>().autologin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Application',
      theme: theme,
      home: StreamBuilder<bool>(
        stream:
            serviceLocator<StreamController<bool>>(instanceName: 'authStream')
                .stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return const BottomNavItems();
          }
          return const Login();
        },
      ),
    );
  }
}
