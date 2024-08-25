import 'package:android_build_maker/config/configurable_text_style.dart';
import 'package:android_build_maker/dialogs/dialog_skin.dart';
import 'package:android_build_maker/io/models/profile_model.dart';
import 'package:android_build_maker/main.dart';
import 'package:android_build_maker/widgets/icon_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CreateEntryDialog extends StatefulWidget {
  const CreateEntryDialog({super.key, this.model});

  final ProfileModel? model;

  static Future<void> show(BuildContext context, [ProfileModel? model]) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return CreateEntryDialog(model: model);
      },
    );
  }

  @override
  State<CreateEntryDialog> createState() => _CreateEntryDialogState();
}

class _CreateEntryDialogState extends State<CreateEntryDialog> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController appNameController = TextEditingController();
  final TextEditingController shopNumberController = TextEditingController();
  ProfileModel model = ProfileModel.empty;

  @override
  void initState() {
    model = widget.model ?? model;
    appNameController.text = model.shopName;
    shopNumberController.text = model.shopNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DialogSkin(
      width: 400,
      height: 413,
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
                      widget.model == null
                          ? "Create Build Profile"
                          : "Edit Build Profile",
                      style: ConfigurableTextStyle.withFontSize(15),
                    ),
                    Wrap(
                      spacing: 10,
                      children: [
                        if (widget.model != null)
                          IconButton(
                            onPressed: () {
                              appStorage.deleteProfile(widget.model, model);
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.delete,
                            ),
                          ),
                        IconButton(
                          onPressed: () {
                            final state = formKey.currentState;
                            if (state != null) {
                              final complete = state.validate();
                              if (complete) {
                                model = ProfileModel.clone(
                                  model,
                                  shopName: appNameController.text,
                                  shopNumber: shopNumberController.text,
                                );
                                appStorage.addProfile(widget.model, model);
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
                    IconPicker(
                      model: model,
                      onChanged: (path) {
                        model = ProfileModel.clone(model, iconPath: path);
                      },
                    ),
                    const Gap(20),
                    SizedBox(
                      child: TextFormField(
                        controller: appNameController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "*Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "App Name",
                          hintText: "e.g: Kirana Fast Online Store",
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
                    ),
                    const Gap(20),
                    SizedBox(
                      child: TextFormField(
                        controller: shopNumberController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "*Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Shop Number",
                          hintText: "   e.g: 8858493997",
                          prefixText: "+91",
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
