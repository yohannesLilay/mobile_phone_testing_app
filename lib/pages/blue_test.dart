import 'package:flutter/material.dart';

class BlueTestScreen extends StatelessWidget {
  const BlueTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blue Test'),
      ),
      body: Container(
        color: Colors.blue,
      ),
    );
  }
}
