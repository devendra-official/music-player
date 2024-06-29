import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/music/viewmodel/bloc/music_bloc.dart';
import 'package:music/features/music/viewmodel/music_model.dart';
import 'package:music/features/upload/view/utils/utils.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MusicBloc, MusicState>(
      listener: (context, state) {
        if (state is MusicFailed) {
          showMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state.music != null) {
          Music music = state.music!;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppPallete.playerBgColor, stringToColor(music.color)],
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Scaffold(
              backgroundColor: AppPallete.transparentColor,
              appBar: AppBar(
                backgroundColor: AppPallete.transparentColor,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.keyboard_arrow_down, size: 38),
                ),
              ),
              body: Column(
                children: [
                  Hero(
                    tag: 'image-url',
                    child: Container(
                      margin: const EdgeInsets.only(top: 15),
                      clipBehavior: Clip.hardEdge,
                      height: 360,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Image.network(music.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          music.songName,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          music.artist,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: stringToColor(music.color),
                          thumbColor: stringToColor(music.color),
                        ),
                        child: Slider(value: 0.5, onChanged: (value) {})),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("0.00"), Text("1:00")],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_previous),
                        iconSize: 54,
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<MusicBloc>().add(MusicPausePlay());
                        },
                        icon: BlocBuilder<MusicBloc, MusicState>(
                          builder: (context, state) {
                            if (state is MusicLoading) {
                              return const CircularProgressIndicator(
                                color: AppPallete.whiteColor,
                              );
                            }
                            if (state is MusicPlaying) {
                              return const Icon(CupertinoIcons.pause_fill);
                            }
                            return const Icon(CupertinoIcons.play_fill);
                          },
                        ),
                        iconSize: 54,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_next),
                        iconSize: 54,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
