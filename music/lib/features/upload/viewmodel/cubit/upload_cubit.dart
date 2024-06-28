import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/features/upload/repository/upload_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit({
    required this.cloudinary,
    required this.preferences,
    required this.uploadRepository,
  }) : super(UploadInitial());

  final SharedPreferences preferences;
  final Cloudinary cloudinary;
  final UploadRepository uploadRepository;

  void uploadMusic({
    required File music,
    required File image,
    required String color,
    required String movie,
    required String artist,
    required String musicName,
  }) async {
    emit(UploadLoading());
    CloudinaryResponse imageUrl = await cloudinary.upload(
      folder: "images",
      fileBytes: image.readAsBytesSync(),
      resourceType: CloudinaryResourceType.image,
    );
    CloudinaryResponse audioUrl = await cloudinary.upload(
      folder: "musics",
      fileBytes: music.readAsBytesSync(),
      resourceType: CloudinaryResourceType.auto,
    );

    if (imageUrl.isSuccessful && audioUrl.isSuccessful) {
      final response = await uploadRepository.uploadMusic(
        imageurl: imageUrl.secureUrl!,
        audiourl: audioUrl.secureUrl!,
        movie: movie,
        artist: artist,
        musicName: musicName,
        color: color,
      );
      response.fold(
        (message) => emit(UploadSuccess(message)),
        (failuer) => emit(UploadFailure(failuer.failure)),
      );
    } else {
      emit(UploadFailure("failed upload files to the server"));
    }
  }
}
