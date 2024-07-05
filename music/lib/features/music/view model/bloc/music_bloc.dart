import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music/features/music/view%20model/music_model.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  static AudioPlayer? player;
  final StreamController<int> currentMusic;

  MusicBloc(this.currentMusic) : super(const MusicInitial(music: null)) {
    on<MusicPlay>(onMusicPlay);
    on<MusicUpdate>(onMusicUpdate);
    on<MusicStateEvent>(onMusicStateEvent);
    on<MusicPausePlay>(onMusicPausePlay);
    on<MusicDispose>(onMusicDispose);
  }

  void onMusicPlay(MusicPlay event, Emitter<MusicState> emit) async {
    try {
      emit(MusicLoading(music: event.music));
      currentMusic.add(event.music.id);
      List<Music> list = event.musicList;
      await player?.stop();
      await player?.dispose();

      player = AudioPlayer();
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: List.generate(list.length, (index) {
          return AudioSource.uri(
            Uri.parse(list[index].songUrl),
            tag: MediaItem(
              id: list[index].id.toString(),
              title: list[index].songName,
              album: list[index].album,
              artUri: Uri.parse(list[index].imageUrl),
            ),
          );
        }),
      );
      player?.setAudioSource(playlist, initialIndex: event.index);
      player?.play();
      emit(MusicPlaying(music: state.music));
      player?.currentIndexStream.listen((index) {
        if (index != null) {
          add(MusicUpdate(music: list[index]));
        }
      });
      player?.playerStateStream.listen((musicState) {
        add(MusicStateEvent(playerSubscription: musicState));
      });
    } catch (e) {
      emit(MusicFailed(
        message: "Error occurred while playing music",
        music: state.music,
      ));
    }
  }

  void onMusicUpdate(MusicUpdate event, Emitter<MusicState> emit) {
    currentMusic.add(event.music.id);
    if (state is MusicLoading) {
      emit(MusicLoading(music: event.music));
    } else if (state is MusicPlaying) {
      emit(MusicPlaying(music: event.music));
    } else {
      emit(MusicPaused(music: event.music));
    }
  }

  void onMusicStateEvent(MusicStateEvent event, Emitter<MusicState> emit) {
    try {
      switch (event.playerSubscription.processingState) {
        case (ProcessingState.loading):
          emit(MusicLoading(music: state.music));
          break;
        case (ProcessingState.buffering):
          emit(MusicLoading(music: state.music));
          break;
        case (ProcessingState.ready):
          if (event.playerSubscription.playing) {
            emit(MusicPlaying(music: state.music));
          } else {
            emit(MusicPaused(music: state.music));
          }
          break;
        default:
          emit(MusicPaused(music: state.music));
          break;
      }
    } catch (e) {
      emit(MusicFailed(music: state.music));
    }
  }

  void onMusicPausePlay(MusicPausePlay event, Emitter<MusicState> emit) async {
    try {
      if (player != null) {
        if (player!.playing) {
          player?.pause();
          emit(MusicPaused(music: state.music));
        } else {
          player?.play();
          emit(MusicPlaying(music: state.music));
        }
      }
    } catch (e) {
      emit(const MusicFailed());
    }
  }

  void onMusicDispose(MusicDispose event, Emitter<MusicState> emit) async {
    await player?.stop();
    await player?.dispose();
    emit(const MusicPaused(music: null));
  }
}
