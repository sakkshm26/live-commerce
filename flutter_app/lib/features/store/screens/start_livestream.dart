import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touchbase/common/widgets/custom_textfield.dart';
import 'package:touchbase/common/widgets/form_button.dart';
import 'package:touchbase/common/widgets/primary_button.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/store/screens/livestream.dart';
import 'package:touchbase/features/store/screens/select_lievestream_products.dart';

class StartLivestreamScreen extends StatefulWidget {
  static const String routeName = '/start-livestream';
  const StartLivestreamScreen({super.key});

  @override
  State<StartLivestreamScreen> createState() => _StartLivestreamScreenState();
}

class _StartLivestreamScreenState extends State<StartLivestreamScreen> {
  final _livestreamFormKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException {
      if (context.mounted) {
        showCustomSnackBar(context: context, message: "Failed to pick image");
      }
    }
  }

  void startLivestream() async {
    Navigator.pushReplacementNamed(
      context,
      SelectLivestreamProductScreen.routeName,
      arguments: {"title": _titleController.text, "image": image},
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _thumbnailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _livestreamFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _titleController,
                        hintText: 'Livestream Title',
                        keyboardType: TextInputType.text,
                        theme: "light",
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        title: "Upload Thumbnail",
                        onPressed: () {
                          pickImage();
                        },
                        width: 180,
                        isLoading: false,
                      ),
                      const SizedBox(height: 10),
                      image != null ? Text(image!.path.split('/').last) : const Text("No Image Uploaded"),
                      // image != null
                      //     ? Image.file(
                      //         image!,
                      //         width: 160,
                      //         height: 160,
                      //         fit: BoxFit.cover,
                      //       )
                      //     : const Text("No thumbnail selected"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FormButton(
              title: 'Start Livestream',
              onPressed: () {
                if (_livestreamFormKey.currentState!.validate()) {
                  startLivestream();
                }
              },
              isLoading: false,
            ),
          ),
        ],
      ),
    );
  }
}
