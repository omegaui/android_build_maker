import 'dart:ui';

import 'package:android_build_maker/config/app_artworks.dart';
import 'package:android_build_maker/config/configurable_text_style.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DialogSkin extends StatelessWidget {
  const DialogSkin({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: MoveWindow(
          child: Container(
            width: 800,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: width,
                      height: height,
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
                      child: child,
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 59.0),
                      child: Stack(
                        children: [
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Image(
                              image: AppArtworks.banner,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 49.0,
                                bottom: 23.52,
                              ),
                              child: Text(
                                "Build Maker",
                                style: ConfigurableTextStyle.withFontSize(18)
                                    .makeSemiBold()
                                    .withColor(Colors.white),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 24.0,
                                bottom: 35.52,
                              ),
                              child: Text(
                                "v1.0",
                                style: ConfigurableTextStyle.withFontSize(12)
                                    .withColor(Colors.white),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 44.0,
                                bottom: 10.52,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  launchUrlString(
                                      'https://github.com/omegaui/android_build_maker/releases');
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Text(
                                    "Check for updates",
                                    style:
                                        ConfigurableTextStyle.withFontSize(12)
                                            .withColor(Colors.white)
                                            .makeSemiBold(),
                                  ),
                                ),
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
          ),
        ),
      ),
    );
  }
}
