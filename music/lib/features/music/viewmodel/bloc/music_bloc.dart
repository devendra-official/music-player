import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/features/music/viewmodel/music_model.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  static AudioPlayer? player;
  StreamSubscription<PlayerState>? playerStateSubscription;

  MusicBloc() : super(const MusicInitial(music: null)) {
    on<MusicPlay>(onMusicPlay);
    on<MusicStateEvent>(onMusicStateEvent);
    on<MusicPausePlay>(onMusicPausePlay);
  }

  void onMusicPlay(MusicPlay event, Emitter<MusicState> emit) async {
    try {
      emit(MusicLoading(music: event.music));
      await player?.stop();
      await player?.dispose();
      await playerStateSubscription?.cancel();

      player = AudioPlayer();
      await player?.setUrl("https://download.samplelib.com/mp3/sample-12s.mp3");
      player?.play();
      emit(MusicPlaying(music: state.music));
      playerStateSubscription = player?.playerStateStream.listen((musicState) {
        add(MusicStateEvent(playerSubscription: musicState));
      });
    } catch (e) {
      emit(MusicFailed(
        message: "Error occurred while playing music",
        music: state.music,
      ));
    }
  }

  void onMusicStateEvent(MusicStateEvent event, Emitter<MusicState> emit) {
    try {
      switch (event.playerSubscription.processingState) {
        case (ProcessingState.loading):
          emit(MusicLoading(music: state.music));
          break;
        case (ProcessingState.idle):
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
      emit(MusicFailed(message: 'something went wrong', music: state.music));
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
      emit(MusicFailed(message: e.toString()));
    }
  }

  static AudioPlayer? get musicPlayer => player;
}
