import 'package:android_build_maker/config/configurable_text_style.dart';
import 'package:android_build_maker/io/persistent_storage.dart';
import 'package:android_build_maker/pages/app_controller.dart';
import 'package:android_build_maker/pages/app_home.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

PersistentStorage appStorage = PersistentStorage();
AppController appController = AppController();

void main() {
  appStorage.init();
  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(1000, 720);
    appWindow.minSize = initialSize;
    appWindow.maxSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Android Build Maker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.green.shade100, width: 3),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 10,
              )
            ],
          ),
          textStyle: ConfigurableTextStyle.withFontSize(14),
        ),
      ),
      color: Colors.transparent,
      home: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 800,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 40,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: MoveWindow(child: const AppHome()),
            ),
          ),
        ),
      ),
    );
  }
}
