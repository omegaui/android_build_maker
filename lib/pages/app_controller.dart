import 'dart:async';

import 'package:android_build_maker/io/models/profile_model.dart';
import 'package:android_build_maker/main.dart';

class AppController {
  Stream<List<ProfileModel>> watchBuildProfiles() {
    final stream = appStorage.watch('profiles');
    final controller = StreamController<List<ProfileModel>>();
    stream.listen((profiles) {
      List<ProfileModel> models = [];
      if (profiles.isNotEmpty) {
        models
            .addAll(profiles.map<ProfileModel>((e) => ProfileModel.fromMap(e)));
      }
      controller.add(models);
    });
    return controller.stream.asBroadcastStream();
  }
}
