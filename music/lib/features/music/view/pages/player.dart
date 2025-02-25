import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/theme/theme.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/music/view%20model/bloc/music_bloc.dart';
import 'package:music/features/music/view%20model/music_model.dart';
import 'package:music/features/music/view/widgets/widgets.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    AudioPlayer? playerState;
    return BlocConsumer<MusicBloc, MusicState>(
      listener: (context, state) {
        if (state is MusicFailed) {
          showMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state.music != null) {
          playerState = MusicBloc.player;
          Music music = state.music!;
          return GradientScaffold(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: () {
                      showMessage(context, "coming soon!");
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),
              backgroundColor: AppPallete.transparentColor,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'image-url',
                    child: Container(
                      margin: const EdgeInsets.only(top: 15),
                      clipBehavior: Clip.hardEdge,
                      height: 360,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: AppPallete.backgroundColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: CustomNetworkImage(url: music.imageUrl),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          music.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      StreamBuilder<Duration>(
                        stream: playerState?.positionStream,
                        builder: (context, snapshot) {
                          return ProgressBar(
                            progressBarColor: AppPallete.white,
                            thumbColor: AppPallete.white,
                            thumbGlowRadius: 1,
                            barHeight: 4,
                            thumbRadius: 5.8,
                            baseBarColor: AppPallete.white30,
                            progress: playerState == null
                                ? Duration.zero
                                : playerState!.position,
                            total: playerState!.duration ?? Duration.zero,
                            onSeek: (value) {
                              playerState?.seek(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          playerState?.seekToPrevious();
                        },
                        icon: const Icon(Icons.skip_previous),
                        iconSize: 74,
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<MusicBloc>().add(MusicPausePlay());
                        },
                        icon: BlocBuilder<MusicBloc, MusicState>(
                          builder: (context, state) {
                            if (state is MusicLoading) {
                              return const CircularProgressIndicator(
                                color: AppPallete.white,
                              );
                            }
                            if (state is MusicPlaying) {
                              return const Icon(Icons.pause_circle);
                            }
                            return const Icon(Icons.play_circle);
                          },
                        ),
                        iconSize: 74,
                      ),
                      IconButton(
                        onPressed: () {
                          playerState?.seekToNext();
                        },
                        icon: const Icon(Icons.skip_next),
                        iconSize: 74,
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
