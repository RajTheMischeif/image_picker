import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/colors.dart';

class HomePageController extends GetxController {
  Rx<bool> isPicked = Rx<bool>(false);
  Rx<File?> imgFile = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo? androidInfo;

  @override
  void onInit() async {
    androidInfo = await getInfo();
    super.onInit();
  }

  Future<void> imagePicker(ImageSource source) async {
    var pickedImg = await picker.pickImage(source: source);
    if (pickedImg != null) {
      imgFile.value = File(pickedImg.path);
      isPicked(false);
      await Future.delayed(const Duration(milliseconds: 2000));
      isPicked(true);
    } else {
      Get.snackbar('Alert!', 'Image not picked',
          backgroundColor: darkBlue, colorText: white);
    }
  }

  Future<AndroidDeviceInfo> getInfo() async {
    return await deviceInfo.androidInfo;
  }
}
