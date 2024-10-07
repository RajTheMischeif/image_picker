import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_viewer/constants/colors.dart';
import 'package:image_viewer/controller/home_screen_controller.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final HomePageController _ctrl = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: black,
        title: Text(
          'Image viewer',
          style: TextStyle(color: darkBlue),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: Get.height * 0.1, left: Get.height * 0.03),
                child: Text(
                  'Take a photo',
                  style:
                      TextStyle(color: darkBlue, fontSize: Get.height * 0.03),
                ),
              ),
              _ctrl.imgFile.value != null
                  ? Padding(
                      padding: EdgeInsets.only(left: Get.height * 0.03),
                      child: Text(
                        'Please ensure that the picture is clear',
                        style: TextStyle(color: darkBlue),
                      ),
                    )
                  : const SizedBox(),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(Get.height * 0.03),
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: _ctrl.isPicked.value ? null : white,
                        borderRadius: BorderRadius.circular(Get.height * 0.02),
                      ),
                      height: Get.height * 0.33,
                      width: _ctrl.isPicked.value ? null : Get.width * 0.7,
                      child: !_ctrl.isPicked.value &&
                              _ctrl.imgFile.value == null
                          ? Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  minimumSize: Size.square(Get.height * 0.05),
                                  backgroundColor: darkBlue,
                                  foregroundColor: white,
                                ),
                                onPressed: () =>
                                    showBottomSheetToPickImg(context),
                                child: Icon(
                                  Icons.add,
                                  size: Get.height * 0.03,
                                ),
                              ),
                            )
                          : !_ctrl.isPicked.value && _ctrl.imgFile.value != null
                              ? Center(
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                          color: darkBlue,
                                          size: Get.height * 0.03),
                                )
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Get.height * 0.02),
                                  child: Image.file(
                                      fit: BoxFit.fill, _ctrl.imgFile.value!),
                                ),
                    ),
                  ),
                ),
              ),
              _ctrl.isPicked.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            minimumSize: Size.square(Get.height * 0.05),
                            backgroundColor: darkBlue,
                            foregroundColor: white,
                          ),
                          onPressed: () => showBottomSheetToPickImg(context),
                          child: Icon(
                            Icons.edit,
                            size: Get.height * 0.03,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            minimumSize: Size.square(Get.height * 0.05),
                            backgroundColor: darkBlue,
                            foregroundColor: white,
                          ),
                          onPressed: () {},
                          child: Icon(
                            Icons.check,
                            size: Get.height * 0.03,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              SizedBox(
                height: Get.height * 0.02,
              )
            ],
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
                              backgroundColor: darkBlue, colorText: white);
                        } else if (status ==
                            PermissionStatus.permanentlyDenied) {
                          Get.snackbar('Access Permanently denied',
                              'You cannot access camera no more, please give the access through the settings',
                              backgroundColor: darkBlue,
                              colorText: white,
                              duration: Duration(milliseconds: 2000));
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: Get.height * 0.034,
                            color: darkBlue,
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
                                backgroundColor: darkBlue, colorText: white);
                          } else if (status == PermissionStatus.limited) {
                            Get.snackbar('Limited Access',
                                'You can access gallery only limited',
                                backgroundColor: darkBlue, colorText: white);
                          } else if (status ==
                              PermissionStatus.permanentlyDenied) {
                            Get.snackbar('Access Permanently denied',
                                'You cannot access gallery no more, please give the access through the settings',
                                backgroundColor: darkBlue,
                                colorText: white,
                                duration: Duration(milliseconds: 2000));
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
                                backgroundColor: darkBlue, colorText: white);
                          } else if (state ==
                              PermissionStatus.permanentlyDenied) {
                            Get.snackbar('Access Permanently denied',
                                'You cannot access gallery no more, please give the access through the settings',
                                backgroundColor: darkBlue,
                                colorText: white,
                                duration: Duration(milliseconds: 2000));
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo,
                            size: Get.height * 0.034,
                            color: darkBlue,
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
