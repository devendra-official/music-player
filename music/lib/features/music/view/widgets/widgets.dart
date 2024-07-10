import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/features/music/view/pages/music_list_page.dart';
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
            child: ListTile(
              tileColor: AppPallete.darkGrey,
              leading: Hero(
                tag: 'image-url',
                child: Container(
                  width: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomNetworkImage(url: music.imageUrl),
                ),
              ),
              title: Text(
                music.songName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                music.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
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
                      return const Icon(CupertinoIcons.pause_fill);
                    }
                    return const Icon(CupertinoIcons.play_fill);
                  },
                ),
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
  const MoreButton({super.key, required this.musicList});

  final List<Music> musicList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MusicListPage(list: musicList);
        }));
      },
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
            child: CustomNetworkImage(
              url: musicData[languages[lan]]!.music[index].imageUrl,
            ),
          ),
          title: Text(
            musicData[languages[lan]]!.music[index].songName,
            maxLines: 1,
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

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/default.jpg',
        fit: BoxFit.cover,
      ),
      fit: BoxFit.cover,
    );
  }
}
