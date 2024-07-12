import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/core/model/user_model.dart';
import 'package:music/features/music/view%20model/cubit/music_lan.dart';
import 'package:music/features/profile/view/pages/personal.dart';
import 'package:music/features/music/view/pages/home.dart';
import 'package:music/features/music/view/widgets/widgets.dart';
import 'package:music/features/music/view%20model/cubit/audiolist_cubit.dart';
import 'package:music/features/upload/view/pages/upload.dart';

class BottomNavItems extends StatefulWidget {
  const BottomNavItems({super.key});

  @override
  State<BottomNavItems> createState() => _BottomNavItemsState();
}

class _BottomNavItemsState extends State<BottomNavItems> {
  int index = 0;
  List<Widget> pages = [
    const HomePage(),
    const UploadPage(),
    const PersonalPage()
  ];

  @override
  void initState() {
    BlocProvider.of<AudiolistCubit>(context).getList();
    BlocProvider.of<MusicByLanguageCubit>(context).getListByLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        selectedFontSize: 12,
        backgroundColor: AppPallete.darkGrey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: index,
        selectedItemColor: AppPallete.white,
        unselectedItemColor: AppPallete.white,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            label: "Home",
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
          ),
          const BottomNavigationBarItem(
            label: "Upload",
            activeIcon: Icon(Icons.add_box),
            icon: Icon(Icons.add_box_outlined),
          ),
          BottomNavigationBarItem(
            label: "You",
            icon: BlocBuilder<UserCubit, UserModel?>(
              builder: (context, state) {
                if (state != null) {
                  return Container(
                    padding: const EdgeInsets.all(1.2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: index == 2
                            ? AppPallete.white
                            : AppPallete.transparentColor,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 14,
                      foregroundImage: CachedNetworkImageProvider(state.user.profileUrl),
                      child: Text(
                        state.user.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }
                return Icon(
                  index == 2
                      ? Icons.account_circle_rounded
                      : Icons.account_circle_outlined,
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          pages[index],
          index == 0
              ? const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: MiniMusicPlayer(),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
