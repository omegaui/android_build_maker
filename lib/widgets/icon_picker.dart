import 'dart:io';

import 'package:android_build_maker/config/app_icons.dart';
import 'package:android_build_maker/io/models/profile_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {
  const IconPicker({
    super.key,
    required this.model,
    required this.onChanged,
  });

  final ProfileModel model;
  final void Function(String path) onChanged;

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  ImageProvider provider = AppIcons.kf;

  @override
  void initState() {
    super.initState();
    provider = FileImage(File(widget.model.iconPath));
  }

  Future<void> pickIcon() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['png', 'jpeg'],
      allowMultiple: false,
      dialogTitle: "Pick Flutter App Icon",
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        provider = FileImage(file);
      });
      widget.onChanged(file.path);
    } else {
      debugPrint("File Picker Cancelled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickIcon,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          message: "Change App Icon",
          margin: const EdgeInsets.only(top: 40),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: provider,
                  width: 96,
                  height: 96,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
