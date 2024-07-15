import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/features/music/view%20model/bloc/music_bloc.dart';
import 'package:music/features/music/view%20model/music_model.dart';
import 'package:music/features/music/view/widgets/widgets.dart';

class MusicListPage extends StatelessWidget {
  const MusicListPage({super.key, required this.list});

  final List<Music> list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Musics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            list.length,
            (index) {
              return BlocBuilder<MusicBloc, MusicState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<MusicBloc>(context).add(MusicPlay(
                        music: list[index],
                        index: index,
                        musicList: list,
                      ));
                    },
                    child: BlocBuilder<MusicBloc, MusicState>(
                      builder: (context, state) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: state.currentId == list[index].id
                                ? AppPallete.darkGrey
                                : AppPallete.transparentColor,
                          ),
                          child: ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  CustomNetworkImage(url: list[index].imageUrl),
                            ),
                            title: Text(
                              list[index].songName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              list[index].artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: state.currentId == list[index].id
                                ? IconButton(
                                    onPressed: () {
                                      context
                                          .read<MusicBloc>()
                                          .add(MusicPausePlay());
                                    },
                                    icon: BlocBuilder<MusicBloc, MusicState>(
                                      builder: (context, state) {
                                        if (state is MusicLoading) {
                                          return const CircularProgressIndicator(
                                            color: AppPallete.white,
                                          );
                                        }
                                        if (state is MusicPlaying) {
                                          return const Icon(
                                              CupertinoIcons.pause_fill);
                                        }
                                        return const Icon(
                                            CupertinoIcons.play_fill);
                                      },
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
