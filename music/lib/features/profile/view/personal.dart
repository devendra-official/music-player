import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/theme/theme.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/authentication/view%20model/cubit/auth_cubit.dart';
import 'package:music/features/authentication/view%20model/user_model.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
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
    );
  }
}
