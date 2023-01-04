import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.onImageSelected, {super.key});

  final void Function(File imageFile) onImageSelected;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  Future<void> _pickImage() async {
    final imageSource = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pickup Image'),
          content: const Text('Where do you want to pick image from?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
    if (imageSource == null || imageSource is! ImageSource) return;
    try {
      final file = await ImagePicker().pickImage(
        source: imageSource,
        // on some devices it can make some crashes
        // imageQuality: 50,
        // maxWidth: 150,
      );
      if (file == null) return;
      setState(() {
        _pickedImage = File(file.path);
        widget.onImageSelected(_pickedImage!);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _pickedImage != null
            ? CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(_pickedImage!),
              )
            : const Icon(
                Icons.person,
                size: 100,
              ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Pickup Image'),
        ),
      ],
    );
  }
}
