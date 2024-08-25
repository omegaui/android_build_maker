import 'package:android_build_maker/widgets/profile_card.dart';
import 'package:android_build_maker/widgets/tool_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../io/models/profile_model.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key, required this.models});

  final List<ProfileModel> models;

  @override
  Widget build(BuildContext context) {
    models.sort((a, b) => a.shopName.compareTo(b.shopName));
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const Gap(80),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: MediaQuery.sizeOf(context).width),
                      const Gap(20),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          ...models.map((e) => ProfileCard(model: e)),
                        ],
                      ),
                      const Gap(100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.topCenter,
          child: ToolBar(),
        ),
      ],
    );
  }
}
