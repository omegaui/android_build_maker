import 'dart:io';

import 'package:android_build_maker/config/app_icons.dart';
import 'package:android_build_maker/main.dart';

class ConfigStorage {
  static String _createConfig(String iconPath) {
    if (iconPath == AppIcons.kf.assetName) {
      iconPath = 'assets/images/shop.png';
    }
    return """
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "$iconPath"
""";
  }

  static Future<void> write(String iconPath) async {
    final repository = appStorage.get<String>('repository', fallback: '');
    final file = File(
        '$repository${Platform.pathSeparator}android_build_maker_config.yaml');
    await file.writeAsString(_createConfig(iconPath), flush: true);
  }
}
