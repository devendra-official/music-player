import 'package:flutter/material.dart';
import 'package:music/features/music/view/pages/home.dart';
import 'package:music/features/music/view/widgets/widgets.dart';
import 'package:music/features/upload/view/pages/upload.dart';

class BottomNavItems extends StatefulWidget {
  const BottomNavItems({super.key});

  @override
  State<BottomNavItems> createState() => _BottomNavItemsState();
}

class _BottomNavItemsState extends State<BottomNavItems> {
  int index = 0;
  List<Widget> pages = [const HomePage(), const UploadPage(), const Library()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: "home",
            tooltip: "home",
            icon: Icon(index == 0 ? Icons.home : Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: "upload",
            tooltip: "upload",
            icon: Icon(index == 1 ? Icons.add_box : Icons.add_box_outlined),
          ),
          BottomNavigationBarItem(
            label: "library",
            tooltip: "library",
            icon: Icon(
              index == 2 ? Icons.library_music : Icons.library_music_outlined,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          pages[index],
          const Positioned(bottom: 0, left: 0, right: 0, child: MiniMusicPlayer())
        ],
      ),
    );
  }
}
