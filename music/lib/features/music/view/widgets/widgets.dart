import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/features/music/view/pages/player.dart';
import 'package:music/features/music/view%20model/bloc/music_bloc.dart';
import 'package:music/features/music/view%20model/music_model.dart';

class MiniMusicPlayer extends StatelessWidget {
  const MiniMusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        if (state.music != null) {
          Music music = state.music!;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const Player();
              }));
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              height: 68,
              width: MediaQuery.of(context).size.width,
              color: AppPallete.darkGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'image-url',
                        child: Container(
                          width: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Image.network(
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/default.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                            music.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              music.songName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              music.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
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
                      )
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

class MoreButton extends StatelessWidget {
  const MoreButton({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
            border: Border.all(color: AppPallete.white),
            borderRadius: BorderRadius.circular(16)),
        child: const Text(
          "More",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class MusicTile extends StatelessWidget {
  const MusicTile({
    super.key,
    required this.languages,
    required this.musicData,
    required this.lan,
    required this.index,
    this.color = AppPallete.transparentColor,
  });

  final List<String> languages;
  final Map<String, MusicModel> musicData;
  final int lan;
  final int index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<MusicBloc>(context).add(MusicPlay(
          music: musicData[languages[lan]]!.music[index],
          index: index,
          musicList: musicData[languages[lan]]!.music,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Image.network(
              musicData[languages[lan]]!.music[index].imageUrl,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/default.jpg',
                  fit: BoxFit.cover,
                );
              },
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            musicData[languages[lan]]!.music[index].songName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            musicData[languages[lan]]!.music[index].artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
