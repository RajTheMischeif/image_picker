import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_viewer/constants/colors.dart';
import 'package:image_viewer/controller/home_screen_controller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final HomePageController _ctrl = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: red,
          foregroundColor: white,
          title: const Text('Image viewer'),
        ),
        body: Center(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !_ctrl.isPicked.value
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: red,
                          foregroundColor: white,
                        ),
                        onPressed: () => showBottomSheetToPickImg(context),
                        child: const Text('Get image'),
                      )
                    : Padding(
                        padding: EdgeInsets.all(Get.height * 0.03),
                        child: Container(
                          decoration: BoxDecoration(
                              color: red,
                              borderRadius:
                                  BorderRadius.circular(Get.height * 0.02)),
                          height: Get.height * 0.4,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Get.height * 0.02),
                            child: GestureDetector(
                              onTap: () => showBottomSheetToPickImg(context),
                              child: Image.file(
                                  fit: BoxFit.fill, _ctrl.imgFile.value!),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheetToPickImg(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: white,
      context: context,
      isDismissible: false,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Get.height * 0.01),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    SizedBox(
                      width: Get.width * 0.03,
                    ),
                    Text(
                      'Select from :',
                      style: TextStyle(fontSize: Get.height * 0.023),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.02),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        PermissionStatus status =
                            await Permission.camera.request();
                        if (status == PermissionStatus.granted) {
                          Get.back();
                          await _ctrl.imagePicker(ImageSource.camera);
                        } else if (status == PermissionStatus.denied) {
                          Get.snackbar(
                              'Access denied', 'You cannot access camera',
                              backgroundColor: red, colorText: white);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: Get.height * 0.034,
                            color: red,
                          ),
                          SizedBox(
                            width: Get.width * 0.03,
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(fontSize: Get.height * 0.017),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    InkWell(
                      onTap: () async {
                        if (int.parse(_ctrl.androidInfo!.version.release) >
                            12) {
                          PermissionStatus status =
                              await Permission.photos.request();
                          if (status == PermissionStatus.granted) {
                            Get.back();
                            await _ctrl.imagePicker(ImageSource.gallery);
                          } else if (status == PermissionStatus.denied) {
                            Get.snackbar(
                                'Access denied', 'You cannot access photos',
                                backgroundColor: red, colorText: white);
                          }
                        } else if (int.parse(
                                _ctrl.androidInfo!.version.release) <
                            13) {
                          PermissionStatus state =
                              await Permission.storage.request();
                          if (state == PermissionStatus.granted) {
                            Get.back();
                            await _ctrl.imagePicker(ImageSource.gallery);
                          } else if (state == PermissionStatus.denied) {
                            Get.snackbar(
                                'Access denied', 'You cannot access photos',
                                backgroundColor: red, colorText: white);
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo,
                            size: Get.height * 0.034,
                            color: red,
                          ),
                          SizedBox(
                            width: Get.width * 0.03,
                          ),
                          Text(
                            'Gallery',
                            style: TextStyle(fontSize: Get.height * 0.017),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
