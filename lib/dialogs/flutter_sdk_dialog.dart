import 'dart:io';

import 'package:android_build_maker/config/configurable_text_style.dart';
import 'package:android_build_maker/dialogs/dialog_skin.dart';
import 'package:android_build_maker/main.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FlutterSDKDialog extends StatefulWidget {
  const FlutterSDKDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return const FlutterSDKDialog();
      },
    );
  }

  @override
  State<FlutterSDKDialog> createState() => _FlutterSDKDialogState();
}

class _FlutterSDKDialogState extends State<FlutterSDKDialog> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController sdkPathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DialogSkin(
      width: 500,
      height: 200,
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Stack(
          children: [
            // toolbar
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Specify Flutter SDK Path",
                      style: ConfigurableTextStyle.withFontSize(15),
                    ),
                    Wrap(
                      children: [
                        IconButton(
                          onPressed: () {
                            final state = formKey.currentState;
                            if (state != null) {
                              final complete = state.validate();
                              if (complete) {
                                appStorage.put<String>(
                                    'sdk', sdkPathController.text);
                                Navigator.pop(context);
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.save,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // content
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const Gap(90),
                    TextFormField(
                      controller: sdkPathController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "*Required";
                        }
                        if (!FileSystemEntity.isDirectorySync(value!)) {
                          return "*Not a folder";
                        }
                        if (!FileSystemEntity.isDirectorySync(
                            '$value${Platform.pathSeparator}bin')) {
                          return "*Not a Flutter SDK";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Flutter SDK Path",
                        hintText: "e.g: ~/flutter",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 3),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
