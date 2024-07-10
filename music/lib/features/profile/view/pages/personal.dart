import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/server/server.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/theme/theme.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/authentication/view%20model/cubit/auth_cubit.dart';
import 'package:music/features/authentication/view%20model/user_model.dart';
import 'package:music/features/music/view%20model/cubit/audiolist_cubit.dart';
import 'package:music/features/music/view%20model/cubit/music_lan.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  TextEditingController server = TextEditingController();
  @override
  void dispose() {
    server.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: BlocListener<ServerCubit, String?>(
        listener: (context, state) {
          if (state != null) {
            BlocProvider.of<AudiolistCubit>(context).getList();
            BlocProvider.of<MusicByLanguageCubit>(context).getListByLanguage();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Profile",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: Column(
            children: [
              BlocBuilder<UserCubit, UserModel?>(
                builder: (context, state) {
                  if (state != null) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          state.user.profileUrl,
                        ),
                        radius: 28,
                      ),
                      title: Text(state.user.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(state.user.email),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: AppPallete.darkGrey,
                        title: const Text("Server address"),
                        content: TextField(
                          controller: server,
                          autofocus: true,
                          decoration:
                              const InputDecoration(hintText: "server address"),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Close"),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<ServerCubit>()
                                  .updateServer(server.text.trim());
                              Navigator.of(context).pop();
                            },
                            child: const Text("Submit"),
                          )
                        ],
                      );
                    },
                  );
                },
                leading: const Icon(Icons.cloud_sync),
                title: const Text('Server address'),
              ),
              ListTile(
                onTap: () {
                  showMessage(context, 'feature will be added soon');
                },
                leading: const Icon(Icons.manage_accounts),
                title: const Text('Update Profile'),
              ),
              ListTile(
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).logout(context);
                },
                leading: const Icon(Icons.logout, color: AppPallete.errorColor),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: AppPallete.errorColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
