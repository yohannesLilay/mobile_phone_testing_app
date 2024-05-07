import 'package:flutter/material.dart';

class RedTestScreen extends StatelessWidget {
  const RedTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Red Test'),
      ),
      body: Container(
        color: Colors.red,
      ),
    );
  }
}
