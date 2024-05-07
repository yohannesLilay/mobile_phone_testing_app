import 'package:flutter/material.dart';

class GreenTestScreen extends StatelessWidget {
  const GreenTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Test'),
      ),
      body: Container(
        color: Colors.green,
      ),
    );
  }
}
