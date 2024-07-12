import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music/features/music/view%20model/music_model.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  static AudioPlayer? player;

  MusicBloc() : super(const MusicInitial(music: null)) {
    on<MusicPlay>(onMusicPlay);
    on<MusicUpdate>(onMusicUpdate);
    on<MusicStateEvent>(onMusicStateEvent);
    on<MusicPausePlay>(onMusicPausePlay);
    on<MusicDispose>(onMusicDispose);
    on<MusicError>(onMusicError);
  }

  void onMusicPlay(MusicPlay event, Emitter<MusicState> emit) async {
    try {
      emit(MusicLoading(music: event.music, currentId: event.music.id));
      List<Music> list = event.musicList;
      await player?.stop();
      await player?.dispose();

      player = AudioPlayer();
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
        useLazyPreparation: false,
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
      emit(MusicPlaying(music: state.music, currentId: state.currentId));
      player?.currentIndexStream.listen((index) {
        if (index != null) {
          add(MusicUpdate(music: list[index]));
        }
      });
      player?.playbackEventStream.listen((event) {},
          onError: (Object e, StackTrace st) {
        if (e is PlatformException) {
          add(MusicError(error: e.message!));
        } else {
          add(MusicError(error: 'Error occurred while playing music'));
        }
      });
      player?.playerStateStream.listen((musicState) {
        add(MusicStateEvent(playerSubscription: musicState));
      });
    } on PlayerException catch (e) {
      emit(MusicFailed(message: e.message ?? 'Error while playing'));
    } on PlayerInterruptedException catch (e) {
      emit(MusicFailed(message: e.message ?? 'Connection aborted'));
    } catch (e) {
      emit(MusicFailed(
        message: "Error occurred while playing music",
        music: state.music,
        currentId: state.currentId,
      ));
    }
  }

  void onMusicError(MusicError event, Emitter<MusicState> emit) {
    emit(MusicFailed(
      message: event.error,
      music: state.music,
      currentId: state.currentId,
    ));
  }

  void onMusicUpdate(MusicUpdate event, Emitter<MusicState> emit) {
    if (state is MusicLoading) {
      emit(MusicLoading(music: event.music, currentId: event.music.id));
    } else if (state is MusicPlaying) {
      emit(MusicPlaying(music: event.music, currentId: event.music.id));
    } else {
      emit(MusicPaused(music: event.music, currentId: event.music.id));
    }
  }

  void onMusicStateEvent(MusicStateEvent event, Emitter<MusicState> emit) {
    try {
      switch (event.playerSubscription.processingState) {
        case (ProcessingState.loading):
          emit(MusicLoading(music: state.music, currentId: state.currentId));
          break;
        case (ProcessingState.buffering):
          emit(MusicLoading(music: state.music, currentId: state.currentId));
          break;
        case (ProcessingState.ready):
          if (event.playerSubscription.playing) {
            emit(MusicPlaying(music: state.music, currentId: state.currentId));
          } else {
            emit(MusicPaused(music: state.music, currentId: state.currentId));
          }
          break;
        default:
          emit(MusicPaused(music: state.music, currentId: state.currentId));
          break;
      }
    } catch (e) {
      emit(MusicFailed(music: state.music, currentId: state.currentId));
    }
  }

  void onMusicPausePlay(MusicPausePlay event, Emitter<MusicState> emit) async {
    try {
      if (player != null) {
        if (player!.playing) {
          player?.pause();
          emit(MusicPaused(music: state.music, currentId: state.currentId));
        } else {
          player?.play();
          emit(MusicPlaying(music: state.music, currentId: state.currentId));
        }
      }
    } catch (e) {
      emit(const MusicFailed());
    }
  }

  void onMusicDispose(MusicDispose event, Emitter<MusicState> emit) async {
    await player?.stop();
    await player?.dispose();
    emit(const MusicPaused(music: null, currentId: null));
  }
}
