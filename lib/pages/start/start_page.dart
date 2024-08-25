import 'package:android_build_maker/config/app_icons.dart';
import 'package:android_build_maker/config/configurable_text_style.dart';
import 'package:android_build_maker/widgets/tool_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Align(
          alignment: Alignment.topCenter,
          child: ToolBar(),
        ),
        Align(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(
                image: AppIcons.broom,
              ),
              Text(
                "Start by adding a build job\nby clicking",
                textAlign: TextAlign.center,
                style: ConfigurableTextStyle.withFontSize(15),
              ),
            ],
          ),
        ),
        const Align(
          child: Padding(
            padding: EdgeInsets.only(left: 290.0, bottom: 60),
            child: Image(
              image: AppIcons.arrow,
              filterQuality: FilterQuality.high,
              isAntiAlias: true,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber,
                  color: Colors.orange,
                ),
                const Gap(10),
                Text(
                  "This is an Internal Organization Product",
                  textAlign: TextAlign.center,
                  style: ConfigurableTextStyle.withFontSize(12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
