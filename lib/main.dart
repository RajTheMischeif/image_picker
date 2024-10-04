import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_viewer/screen/home_screen.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Image viewer',
      home: MyHomePage(),
    );
  }
}
