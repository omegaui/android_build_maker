import 'package:android_build_maker/config/app_icons.dart';

class ProfileModel {
  final String iconPath;
  final String shopName;
  final String shopNumber;

  ProfileModel({
    required this.iconPath,
    required this.shopName,
    required this.shopNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'icon': iconPath,
      'shopName': shopName,
      'shopNumber': shopNumber,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      iconPath: map['icon'],
      shopName: map['shopName'],
      shopNumber: map['shopNumber'],
    );
  }

  static ProfileModel get empty => ProfileModel(
        iconPath: AppIcons.kf.assetName,
        shopName: '',
        shopNumber: '',
      );

  factory ProfileModel.clone(
    ProfileModel model, {
    String? iconPath,
    String? shopName,
    String? shopNumber,
  }) {
    return ProfileModel(
      iconPath: iconPath ?? model.iconPath,
      shopName: shopName ?? model.shopName,
      shopNumber: shopNumber ?? model.shopNumber,
    );
  }
}
