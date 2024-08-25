import 'dart:io';

import 'package:android_build_maker/config/configurable_text_style.dart';
import 'package:android_build_maker/dialogs/create_entry_dialog.dart';
import 'package:android_build_maker/io/build_manager.dart';
import 'package:android_build_maker/io/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
    required this.model,
  });

  final ProfileModel model;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _hover = false;

  @override
  void initState() {
    BuildManager.states[widget.model.shopNumber] = () {
      if (mounted) {
        setState(() {});
      }
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final status = BuildManager.status[widget.model.shopNumber];
    bool failed = false;
    bool completed = false;
    bool inQueue = BuildManager.status.containsKey(widget.model.shopNumber);
    if (status != null) {
      failed = status.contains('Failed');
      completed = status.contains('success');
    }
    bool inProgress = inQueue && !failed && !completed;
    return MouseRegion(
      onEnter: (e) => setState(() => _hover = true),
      onExit: (e) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: MediaQuery.sizeOf(context).width / 4 - 40,
        height: 220,
        decoration: BoxDecoration(
          color: (_hover && !inProgress)
              ? Colors.grey.shade200
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: (inProgress || completed || failed)
              ? [
                  BoxShadow(
                    color: completed
                        ? Colors.deepPurple.withOpacity(0.3)
                        : (failed
                            ? Colors.red.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3)),
                    blurRadius: completed ? 40 : 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            if (!inProgress)
              Align(
                alignment: Alignment.topLeft,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _hover ? 1.0 : 0.0,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      tooltip: 'Modify Profile',
                      onPressed: () {
                        CreateEntryDialog.show(context, widget.model);
                      },
                      icon: const Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              ),
            if (!inProgress)
              Align(
                alignment: Alignment.topRight,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _hover ? 1.0 : 0.0,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      tooltip:
                          (completed || failed) ? 'Build Again' : "Build App",
                      onPressed: () {
                        BuildManager.startBuild(context, widget.model);
                      },
                      icon: const Icon(
                        Icons.bubble_chart,
                      ),
                    ),
                  ),
                ),
              ),
            Align(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(widget.model.iconPath),
                          width: 64,
                          height: 64,
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    widget.model.shopName,
                    style: ConfigurableTextStyle.withFontSize(16),
                  ),
                  Text(
                    "+91${widget.model.shopNumber}",
                    style: ConfigurableTextStyle.withFontSize(12),
                  ),
                ],
              ),
            ),
            if (status != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!completed)
                      Text(
                        status,
                        style: ConfigurableTextStyle.withFontSize(12),
                      ),
                    const Gap(4),
                    if (inProgress)
                      const SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(),
                      ),
                    if (completed)
                      TextButton(
                        onPressed: () {
                          launchUrlString(
                              'file://${File('.omegaui/builds').absolute.path}');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: Text(
                          "Click to View",
                          style: ConfigurableTextStyle.withFontSize(14)
                              .withColor(Colors.white),
                        ),
                      ),
                    const Gap(10),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
