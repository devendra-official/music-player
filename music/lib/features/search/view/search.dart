import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/music/view%20model/bloc/music_bloc.dart';
import 'package:music/features/music/view/pages/player.dart';
import 'package:music/features/music/view/widgets/widgets.dart';
import 'package:music/features/search/view%20model/cubit/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                width: MediaQuery.of(context).size.width / 1.3,
                decoration: BoxDecoration(
                  border: Border.all(color: AppPallete.borderColor),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search for song or album',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  onChanged: (value) {
                    context.read<SearchCubit>().searchMusic(value.trim());
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'cancel',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            ],
          )
        ],
      ),
      body: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          if (state is SearchFailed) {
            showMessage(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchSuccess) {
            return SingleChildScrollView(
              child: Column(
                children: List.generate(state.music.length, (index) {
                  return ListTile(
                    onTap: () {
                      context.read<MusicBloc>().add(
                            MusicPlay(
                              music: state.music[index],
                              index: 0,
                              musicList: [state.music[index]],
                            ),
                          );
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const Player();
                      }));
                    },
                    leading: Container(
                      height: 50,
                      width: 50,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          CustomNetworkImage(url: state.music[index].imageUrl),
                    ),
                    title: Text(state.music[index].songName),
                    subtitle: Text(state.music[index].album),
                  );
                }),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
