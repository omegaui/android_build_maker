import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_build_maker/io/models/profile_model.dart';

const _root = '.omegaui/android_build_maker/storage.json';
const _jsonEncoder = JsonEncoder.withIndent('  ');

void _debugPrint(dynamic line) {
  stdout.writeln(line);
}

class PersistentStorage {
  Map<String, dynamic> _storage = {};
  final Map<String, StreamController<dynamic>> _listeners = {};

  void init() {
    if (FileSystemEntity.isFileSync(_root)) {
      final content = File(_root).readAsStringSync();
      _storage = jsonDecode(content);
    }
  }

  void listen<T>({
    required String key,
    required void Function(T value) callback,
  }) {
    var controller = _listeners[key];
    controller ??= StreamController<T>();
    _listeners[key] = controller;
    controller.stream.asBroadcastStream().listen(
      (event) {
        callback(event as T);
      },
    );
  }

  Stream<T> watch<T>(String key) {
    var controller = _listeners[key];
    controller ??= StreamController<T>();
    _listeners[key] = controller;
    return (controller.stream as Stream<T>).asBroadcastStream();
  }

  T get<T>(String key, {required T fallback}) {
    final value = _storage[key];
    if (value != null) {
      return value as T;
    }
    _debugPrint('[Storage] Missing property "$key"');
    return fallback;
  }

  void put<T>(String key, T value) {
    _storage[key] = value;
    _save();
    _debugPrint('[Storage] Saved "$value" in "$key"');
    final controller = _listeners[key];
    if (controller != null) {
      controller.add(value);
    }
  }

  void addProfile(ProfileModel? oldModel, ProfileModel model) {
    var list = _storage['profiles'];
    list ??= <dynamic>[];
    list.removeWhere((e) =>
        e['shopNumber'] == model.shopNumber ||
        e['shopNumber'] == oldModel?.shopNumber);
    list.add(model.toMap());
    put('profiles', list);
    _save();
    _debugPrint('[Storage] Added "${model.shopName}" in "profiles"');
  }

  void _save() {
    final file = File(_root);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(_jsonEncoder.convert(_storage), flush: true);
  }

  void deleteProfile(ProfileModel? oldModel, ProfileModel model) {
    var list = _storage['profiles'];
    list ??= <dynamic>[];
    list.removeWhere((e) =>
        e['shopNumber'] == model.shopNumber ||
        e['shopNumber'] == oldModel?.shopNumber);
    put('profiles', list);
    _save();
    _debugPrint('[Storage] Removed "${model.shopName}" from "profiles"');
  }
}
