import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/music/viewmodel/bloc/music_bloc.dart';
import 'package:music/features/music/viewmodel/cubit/audiolist_cubit.dart';
import 'package:music/features/music/viewmodel/music_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Home Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AudiolistCubit, AudiolistState>(
          listener: (context, state) {
            if (state is AudiolistFailure) {
              showMessage(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AudiolistLoading) {
              return const LinearProgressIndicator();
            }
            if (state is AudiolistSuccess) {
              List<Music> list = state.musicModel.music;
              return SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Latest Songs",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(list.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              BlocProvider.of<MusicBloc>(context)
                                  .add(MusicPlay(music: list[index]));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  height: 154,
                                  width: 134,
                                  decoration: BoxDecoration(
                                    color: AppPallete.inactiveSeekColor,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Image.network(
                                    state.musicModel.music[index].imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  width: 134,
                                  child: Text(
                                    list[index].songName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
