import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/features/music/viewmodel/music_model.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  AudioPlayer? player;

  MusicBloc() : super(const MusicInitial(music: null)) {
    on<MusicPlay>((event, emit) async {
      try {
        emit(MusicLoading(music: event.music));
        await player?.stop();
        await player?.dispose();
        player = AudioPlayer();
        await player?.setUrl(event.music.songUrl);
        player?.play();
        emit(MusicPlaying(music: state.music));
      } catch (e) {
        emit(MusicFailed(message: e.toString(), music: state.music));
      }
    });

    on<MusicPausePlay>((event, emit) async {
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
    });
  }
}
