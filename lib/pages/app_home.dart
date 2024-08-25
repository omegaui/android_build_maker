import 'package:android_build_maker/config/app_artworks.dart';
import 'package:android_build_maker/config/configurable_text_style.dart';
import 'package:android_build_maker/io/models/profile_model.dart';
import 'package:android_build_maker/main.dart';
import 'package:android_build_maker/pages/gallery/gallery_page.dart';
import 'package:android_build_maker/pages/start/start_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: StreamBuilder<List<ProfileModel>>(
              stream: appController.watchBuildProfiles(),
              initialData: (() {
                List<ProfileModel> models = [];
                final profiles = appStorage.get('profiles', fallback: []);
                if (profiles.isNotEmpty) {
                  models.addAll(profiles
                      .map<ProfileModel>((e) => ProfileModel.fromMap(e)));
                }
                return models;
              })(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final profiles = snapshot.data!;
                  if (profiles.isEmpty) {
                    return const StartPage();
                  } else {
                    return GalleryPage(models: profiles);
                  }
                }
                return const StartPage();
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 287,
                    height: 1,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4D9FEB),
                          Color(0xFF11DF95),
                        ],
                      ),
                    ),
                  ),
                ),
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
                          style: ConfigurableTextStyle.withFontSize(12)
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
        ],
      ),
    );
  }
}
