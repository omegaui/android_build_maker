import 'dart:io';

import 'package:android_build_maker/config/configurable_text_style.dart';
import 'package:android_build_maker/dialogs/flutter_sdk_dialog.dart';
import 'package:android_build_maker/dialogs/repository_dialog.dart';
import 'package:android_build_maker/io/config_storage.dart';
import 'package:android_build_maker/io/models/profile_model.dart';
import 'package:android_build_maker/main.dart';
import 'package:flutter/material.dart';

class BuildManager {
  static Map<String, String?> status = {};
  static Map<String, VoidCallback> states = {};
  static ProfileModel? activeModel;
  static List<ProfileModel> waitingModels = [];

  static void updateState(ProfileModel model, String? message) {
    status[model.shopNumber] = message;
    if (states.containsKey(model.shopNumber)) {
      states[model.shopNumber]!.call();
    }
  }

  static Future<void> startBuild(
      BuildContext context, ProfileModel? model) async {
    if (activeModel != null && model != null) {
      waitingModels.add(model);
      updateState(model, 'Waiting');
      return;
    }
    activeModel = model;
    var repository = appStorage.get<String>('repository', fallback: "");
    if (repository.isEmpty) {
      await RepositoryDialog.show(context);
    }
    repository = appStorage.get<String>('repository', fallback: "");
    if (repository.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You can clone the project with \"git clone https://gitlab.com/xeroapps/kf_online_store\"",
            style:
                ConfigurableTextStyle.withFontSize(16).withColor(Colors.white),
          ),
        ),
      );
      return;
    }
    var flutterSDKPath = appStorage.get<String>('sdk', fallback: "");
    if (flutterSDKPath.isEmpty) {
      await FlutterSDKDialog.show(context);
    }
    flutterSDKPath = appStorage.get<String>('sdk', fallback: "");
    if (flutterSDKPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You need to specify which Flutter SDK you want to use.",
            style:
                ConfigurableTextStyle.withFontSize(16).withColor(Colors.white),
          ),
        ),
      );
      return;
    }
    updateState(activeModel!, 'Removing Intermediates');
    final intermediates =
        '$repository${Platform.pathSeparator}build${Platform.pathSeparator}app${Platform.pathSeparator}intermediates';
    final intermediatesDir = Directory(intermediates);
    if (await intermediatesDir.exists()) {
      await intermediatesDir.delete(recursive: true);
    }
    updateState(activeModel!, 'Generating App Icons');
    final flutter =
        "$flutterSDKPath${Platform.pathSeparator}bin${Platform.pathSeparator}flutter${Platform.isWindows ? '.bat' : ''}";
    await ConfigStorage.write(activeModel!.iconPath);
    var result = await Process.run(
      flutter,
      [
        'pub',
        'run',
        'flutter_launcher_icons',
        '-f',
        'android_build_maker_config.yaml',
      ],
      workingDirectory: repository,
    );
    if (result.exitCode != 0) {
      updateState(activeModel!, "Failed to generate icons");
      waitingModels.clear();
      return;
    }
    updateState(activeModel!, 'Updating App Name');
    final manifest =
        '$repository${Platform.pathSeparator}android${Platform.pathSeparator}app${Platform.pathSeparator}src${Platform.pathSeparator}main${Platform.pathSeparator}AndroidManifest.xml';
    final manifestFile = File(manifest);
    if (!(await manifestFile.exists())) {
      updateState(activeModel!, "No Android Manifest Found");
      waitingModels.clear();
      return;
    }
    var contents = await manifestFile.readAsString();
    const androidLabel = 'android:label=';
    var quote1 = contents.indexOf(androidLabel) + androidLabel.length;
    var quote2 = contents.indexOf('"', quote1 + 1);
    var part1 = contents.substring(0, quote1 + 1);
    var part2 = contents.substring(quote2);
    var newContents = part1 + activeModel!.shopName + part2;
    await manifestFile.writeAsString(newContents, flush: true);
    updateState(activeModel!, 'Updating Shop Number');
    final webUtils =
        '$repository${Platform.pathSeparator}lib${Platform.pathSeparator}utils${Platform.pathSeparator}web_utils.dart';
    final webUtilsFile = File(webUtils);
    if (!(await webUtilsFile.exists())) {
      updateState(activeModel!, "Source File is Missing");
      waitingModels.clear();
      return;
    }
    contents = await webUtilsFile.readAsString();
    const masterPhoneNumberLabel = 'const masterPhoneNumber = ';
    quote1 = contents.indexOf(masterPhoneNumberLabel) +
        masterPhoneNumberLabel.length;
    quote2 = contents.indexOf('"', quote1 + 1);
    part1 = contents.substring(0, quote1 + 1);
    part2 = contents.substring(quote2);
    newContents = part1 + activeModel!.shopNumber + part2;
    await webUtilsFile.writeAsString(newContents, flush: true);
    // building application
    updateState(activeModel!, 'Building Android App');
    result = await Process.run(
      flutter,
      [
        'build',
        'apk',
        '--release',
      ],
      workingDirectory: repository,
    );
    if (result.exitCode != 0) {
      updateState(activeModel!, "Failed to generate application");
      waitingModels.clear();
      print(result.stdout);
      print(result.stderr);
      return;
    }
    // moving release apk to a secure location
    updateState(activeModel!, 'Securing output');
    const appDir = '.omegaui/builds';
    if (!(await FileSystemEntity.isDirectory(appDir))) {
      await Directory(appDir).create(recursive: true);
    }
    final output =
        '$repository${Platform.pathSeparator}build${Platform.pathSeparator}app${Platform.pathSeparator}outputs${Platform.pathSeparator}flutter-apk${Platform.pathSeparator}app-release.apk';
    final releaseAPK = File(output);
    final secureLocation =
        '$appDir${Platform.pathSeparator}${activeModel!.shopName}.apk';
    await releaseAPK.rename(secureLocation);
    // on build completed
    updateState(activeModel!, 'success');
    activeModel = null;
    if (waitingModels.isNotEmpty) {
      startBuild(context, waitingModels.removeAt(0));
    }
  }
}
