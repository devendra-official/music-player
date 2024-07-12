import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/theme/theme.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/core/widgets/widget.dart';
import 'package:music/features/upload/view/utils/utils.dart';
import 'package:music/features/upload/view%20model/cubit/upload_cubit.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController artistController = TextEditingController();
  TextEditingController albumController = TextEditingController();
  TextEditingController musicController = TextEditingController();
  TextEditingController langController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? selectedFile;
  File? selectedImage;
  String title = "Select Music File";

  @override
  void dispose() {
    albumController.dispose();
    artistController.dispose();
    musicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Upload Music",
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            BlocBuilder<UploadCubit, UploadState>(
              builder: (context, state) {
                if (state is UploadLoading) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const CircularProgressIndicator.adaptive(
                      strokeWidth: 3,
                      backgroundColor: AppPallete.transparentColor,
                      valueColor: AlwaysStoppedAnimation(AppPallete.white),
                    ),
                  );
                }
                return IconButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (selectedFile == null || selectedImage == null) {
                        showMessage(context,
                            "Please select the neccessory files and color");
                      } else {
                        BlocProvider.of<UploadCubit>(context).uploadMusic(
                          music: selectedFile!,
                          image: selectedImage!,
                          artist: artistController.text.trim(),
                          album: albumController.text.trim(),
                          musicName: musicController.text.trim(),
                          language: langController.text.trim().toUpperCase(),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.done),
                );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocListener<UploadCubit, UploadState>(
              listener: (context, state) {
                if (state is UploadFailure) {
                  showMessage(context, state.message);
                }
                if (state is UploadSuccess) {
                  showMessage(context, state.message);
                }
              },
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      File? image = await pickImage();
                      if (image != null) {
                        selectedImage = image;
                        setState(() {});
                      }
                    },
                    child: selectedImage != null
                        ? SizedBox(
                            height: 150,
                            child:
                                Image.file(selectedImage!, fit: BoxFit.cover),
                          )
                        : DottedBorder(
                            color: AppPallete.borderColor,
                            radius: const Radius.circular(4),
                            borderType: BorderType.RRect,
                            dashPattern: const [6, 2],
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(Icons.add_a_photo_outlined,
                                      size: 36),
                                  Text(
                                    "select image to upload",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic>? audio = await pickFile();
                      if (audio != null) {
                        selectedFile = audio["file"];
                        title = audio["name"];
                        setState(() {});
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppPallete.borderColor,
                        ),
                      ),
                      child: Text(title,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomForm(
                          controller: musicController,
                          label: "Song",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "this field can't be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomForm(
                          controller: albumController,
                          label: "Album",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "this field can't be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomForm(
                          controller: artistController,
                          label: "Artist",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "this field can't be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomForm(
                          controller: langController,
                          label: "Language",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "this field can't be empty";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
