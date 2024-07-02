import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/theme/theme.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/music/view/widgets/widgets.dart';
import 'package:music/features/music/view%20model/bloc/music_bloc.dart';
import 'package:music/features/music/view%20model/cubit/audiolist_cubit.dart';
import 'package:music/features/music/view%20model/music_model.dart';
import 'package:music/features/search/view/search.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const SearchPage();
                }));
              },
              icon: const Icon(Icons.search),
            )
          ],
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
                List<Music>? list = state.musicModel.music;
                return SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Latest Songs",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
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
                                    .add(MusicPlay(
                                  music: list[index],
                                  musicList: list,
                                  index: index,
                                ));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    height: 154,
                                    width: 134,
                                    decoration: BoxDecoration(
                                      color: AppPallete.containerBgColor,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Image.network(
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/default.jpg',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      state.musicModel.music[index].imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
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
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Explore",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Explore(),
                      ),
                      const SizedBox(height: 100)
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
