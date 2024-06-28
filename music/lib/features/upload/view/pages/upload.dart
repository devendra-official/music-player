import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/authentication/view/widgets/widget.dart';
import 'package:music/features/upload/view/utils/utils.dart';
import 'package:music/features/upload/viewmodel/cubit/upload_cubit.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController artistController = TextEditingController();
  TextEditingController movieController = TextEditingController();
  TextEditingController musicController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Color? selectedColor;
  File? selectedFile;
  File? selectedImage;
  String title = "Select Music File";

  @override
  void dispose() {
    movieController.dispose();
    artistController.dispose();
    musicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                    valueColor: AlwaysStoppedAnimation(AppPallete.whiteColor),
                  ),
                );
              }
              return IconButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (selectedColor == null ||
                        selectedFile == null ||
                        selectedImage == null) {
                      showMessage(context,
                          "Please select the neccessory files and color");
                    } else {
                      String color = colorToString(selectedColor!);
                      BlocProvider.of<UploadCubit>(context).uploadMusic(
                        music: selectedFile!,
                        image: selectedImage!,
                        artist: artistController.text.trim(),
                        movie: movieController.text.trim(),
                        musicName: musicController.text.trim(),
                        color: color,
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
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        controller: movieController,
                        label: "Movie",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "this field can't be null";
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
                            return "this field can't be null";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomForm(
                        controller: musicController,
                        label: "Song",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "this field can't be null";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                ColorPicker(
                  onColorChanged: (Color color) {
                    selectedColor = color;
                  },
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.wheel: true,
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
