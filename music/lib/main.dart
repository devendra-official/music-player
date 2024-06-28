import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/theme.dart';
import 'package:music/features/authentication/viewmodel/cubit/auth_cubit.dart';
import 'package:music/features/music/view/pages/bottom.dart';
import 'package:music/features/music/viewmodel/bloc/music_bloc.dart';
import 'package:music/features/music/viewmodel/cubit/audiolist_cubit.dart';
import 'package:music/features/upload/viewmodel/cubit/upload_cubit.dart';
import 'package:music/init_dependency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initdependencyfun();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => serviceLocator<AuthCubit>()),
      BlocProvider(create: (context) => serviceLocator<UploadCubit>()),
      BlocProvider(create: (context) => serviceLocator<AudiolistCubit>()),
      BlocProvider(create: (context) => MusicBloc())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: const BottomNavItems(),
    );
  }
}
