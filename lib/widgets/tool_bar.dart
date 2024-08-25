import 'dart:io';

import 'package:android_build_maker/config/configurable_text_style.dart';
import 'package:android_build_maker/dialogs/create_entry_dialog.dart';
import 'package:android_build_maker/dialogs/flutter_sdk_dialog.dart';
import 'package:android_build_maker/dialogs/repository_dialog.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
            "Make Online Store Builds with Ease",
            style: ConfigurableTextStyle.withFontSize(15),
          ),
          Wrap(
            spacing: 10,
            children: [
              IconButton(
                tooltip: 'View Builds',
                onPressed: () {
                  launchUrlString(
                      'file://${File('.omegaui/builds').absolute.path}');
                },
                icon: const Icon(
                  Icons.sd_card_rounded,
                ),
              ),
              IconButton(
                tooltip: 'Set Repository',
                onPressed: () {
                  RepositoryDialog.show(context);
                },
                icon: const Icon(
                  Icons.flutter_dash,
                ),
              ),
              IconButton(
                tooltip: 'Create Profile',
                onPressed: () {
                  CreateEntryDialog.show(context);
                },
                icon: const Icon(
                  Icons.add_business_outlined,
                ),
              ),
              IconButton(
                tooltip: 'Set Flutter SDK',
                onPressed: () {
                  FlutterSDKDialog.show(context);
                },
                icon: const FlutterLogo(
                  style: FlutterLogoStyle.markOnly,
                  textColor: Colors.black,
                  curve: Curves.easeIn,
                ),
              ),
              IconButton(
                onPressed: () {
                  appWindow.close();
                },
                icon: const Icon(
                  Icons.close,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
