import 'package:flutter/material.dart';
import 'package:screen_touch_test/pages/blue_test.dart';
import 'package:screen_touch_test/pages/detect_sim.dart';
import 'package:screen_touch_test/pages/device_information.dart';
import 'package:screen_touch_test/pages/green_test.dart';
import 'package:screen_touch_test/pages/home.dart';
import 'package:screen_touch_test/pages/red_test.dart';
import 'package:screen_touch_test/pages/sensor_test.dart';
import 'package:screen_touch_test/pages/speaker_test.dart';
import 'package:screen_touch_test/pages/sub_key_test.dart';
import 'package:screen_touch_test/pages/touch_screen_test.dart';
import 'package:screen_touch_test/pages/vibration_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touch Screen Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/red_screen': (context) => const RedTestScreen(),
        '/green_screen': (context) => const GreenTestScreen(),
        '/blue_screen': (context) => const BlueTestScreen(),
        '/touch_test_screen': (context) => const TouchTestScreen(),
        '/speaker_screen': (context) => const SpeakerTestScreen(),
        '/sensor_screen': (context) => const SensorTestScreen(),
        '/sub_key_screen': (context) => const SubKeyTestScreen(),
        '/vibration_screen': (context) => const VibrationTestScreen(),
        '/detect_sim_screen': (context) =>  const DetectSimScreen(),
        '/device_information_screen': (context) => const DeviceInformationScreen(),
      },
    );
  }
}
