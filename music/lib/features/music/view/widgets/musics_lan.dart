import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/features/music/view%20model/bloc/music_bloc.dart';
import 'package:music/features/music/view%20model/cubit/music_lan.dart';
import 'package:music/features/music/view%20model/music_model.dart';
import 'package:music/features/music/view/widgets/widgets.dart';

class MusicByLanguage extends StatelessWidget {
  const MusicByLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BlocBuilder<MusicByLanguageCubit, MusicByLanguageState>(
        builder: (context, state) {
          if (state is MusicByLanguageSuccess) {
            List<String> languages = state.languages;
            Map<String, MusicModel> musicData = state.musicData;
            return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(languages.length, (lan) {
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.84,
                        padding: const EdgeInsets.only(left: 10, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              languages[lan],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            MoreButton(
                              musicList: musicData[languages[lan]]!.music,
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.84,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          children: List.generate(
                            musicData[languages[lan]]!.music.length > 5
                                ? 5
                                : musicData[languages[lan]]!.music.length,
                            (index) {
                              return BlocBuilder<MusicBloc, MusicState>(
                                builder: (context, state) {
                                  return MusicTile(
                                    languages: languages,
                                    musicData: musicData,
                                    lan: lan,
                                    index: index,
                                    color: state.currentId ==
                                            musicData[languages[lan]]!
                                                .music[index]
                                                .id
                                        ? AppPallete.darkGrey
                                        : AppPallete.transparentColor,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
